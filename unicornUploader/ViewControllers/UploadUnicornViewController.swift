//
//  UploadUnicornViewController.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit

class UploadUnicornViewController: UIViewController {

    // MARK: - Outlets and outlet functions
    @IBOutlet weak var unicornImageView: UIImageView!
    @IBOutlet weak var addedBy: UITextField!
    @IBOutlet weak var seenAt: UITextField!
    @IBOutlet weak var submitButton: UIButton!

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

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UploadUnicornViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(animated: true, completion: nil)
        // TODO: Implement picture upload

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
