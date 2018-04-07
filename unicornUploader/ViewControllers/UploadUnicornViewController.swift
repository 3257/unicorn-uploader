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
        let unicorn = Unicorn(imagePath: storageImagePath, addedBy: addedBy, seenAt: seenAt)

        writeUnicornToDatabase(unicorn)

        // Return to Unicorns Table VC
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
    fileprivate let picker = UIImagePickerController()
    fileprivate var storageImagePath = ""
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    fileprivate var storageUploadTask: StorageUploadTask!

    // Setup for activity indicator to be shown when uploading image
    fileprivate var showNetworkActivityIndicator = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = showNetworkActivityIndicator
        }
    }

    // MARK: - Functions
    fileprivate func writeUnicornToDatabase(_ unicorn: Unicorn) {
        ref.child("unicorns").child(unicorn.seenAt + "\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(unicorn.toAnyObject())
    }

    fileprivate func uploadSuccess(_ metadata: StorageMetadata, _ storagePath: String, _ storageImage: UIImage) {

        // Shpw updated image for unicorn
        unicornImageView.image = storageImage
        // Updated path for image
        storageImagePath = storagePath

        // Enable submit button and change its color
        submitButton.isEnabled = true
        submitButton.backgroundColor = .green
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup references for database and for storage
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()

        // Submit button should be disable initially
        submitButton.isEnabled = false
        submitButton.backgroundColor = .gray

        picker.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // If VC is popping, stop showing networking activity indicator and cancel storageUploadTask if any
        if self.isMovingFromParentViewController {
            showNetworkActivityIndicator = false
            storageUploadTask?.cancel()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UploadUnicornViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData = UIImageJPEGRepresentation(image, 0.5) else {
                print("Could not get Image JPEG Representation")
                return
        }

        let imagePath = Auth.auth().app!.options.googleAppID + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        showNetworkActivityIndicator = true

        storageUploadTask = self.storageRef.child(imagePath).putData(imageData, metadata: metadata) { (metadata, error) in
            self.showNetworkActivityIndicator = false
            guard error == nil else {
                print("Error uploading: \(error!)")
                return
            }
            self.uploadSuccess(metadata!, imagePath, image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
