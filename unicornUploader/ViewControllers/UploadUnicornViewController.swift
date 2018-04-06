//
//  UploadUnicornViewController.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class UploadUnicornViewController: UIViewController {

    // MARK: - Outlets and outlet functions
    @IBOutlet weak var unicornImageView: UIImageView!
    @IBOutlet weak var addedBy: UITextField!
    @IBOutlet weak var seenAt: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    @IBAction func didTapSubmit(_ sender: UIButton) {
        let addedBy = self.addedBy.text ?? ""
        let seenAt = self.seenAt.text ?? ""
        ref.child("unicorns").child(seenAt + "\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(Unicorn(imagePath: storageImagePath, addedBy: addedBy, seenAt: seenAt).toAnyObject())
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        present(picker, animated: true, completion: nil)
    }

    // MARK: - Variables
    let picker = UIImagePickerController()
    var storageImagePath = ""
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var storageUploadTask: StorageUploadTask!

    // MARK: - Functions
    func uploadSuccess(_ metadata: StorageMetadata, _ storagePath: String, _ storageImage: UIImage) {
        print("Upload Succeeded!")
        unicornImageView.image = storageImage
        storageImagePath = storagePath

        submitButton.isEnabled = true
        submitButton.backgroundColor = .green
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        submitButton.isEnabled = false
        submitButton.backgroundColor = .gray
        picker.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            storageUploadTask.cancel()
        }
    }
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UploadUnicornViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else { return }

        let imagePath = Auth.auth().app!.options.googleAppID + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageUploadTask = self.storageRef.child(imagePath).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                return
            }
            self.uploadSuccess(metadata!, imagePath, image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
