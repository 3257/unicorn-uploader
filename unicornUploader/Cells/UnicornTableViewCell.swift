//
//  UnicornTableViewCell.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit
import FirebaseStorage

class UnicornTableViewCell: UITableViewCell {

    @IBOutlet weak var unicornImageView: UIImageView!
    @IBOutlet weak var addedBy: UILabel!
    @IBOutlet weak var seenAt: UILabel!

    var storageRef: StorageReference!
    var storageDownloadTask: StorageDownloadTask!

    var unicorn: Unicorn? {
        didSet {
            if let unicorn = unicorn {
                downloadImage(from: unicorn.imagePath)
                addedBy.text = unicorn.addedBy
                seenAt.text = unicorn.seenAt
            }
        }
    }

    func downloadImage(from storageImagePath: String) {
        // 1. Get a filePath to save the image at
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        // 2. Get the url of that file path
        guard let fileURL = URL(string: filePath) else { return }

        // 3. Start download of image and write it to the file url
        storageDownloadTask = storageRef.child(storageImagePath).write(toFile: fileURL, completion: { (url, error) in
            // 4. Check for error
            if let error = error {
                print("Error downloading:\(error)")
                return
                // 5. Get the url path of the image
            } else if let imagePath = url?.path {
                // 6. Update the unicornImageView image
                self.unicornImageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
        // 7. Finish download of image
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        storageRef = Storage.storage().reference()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        storageDownloadTask.cancel()
        unicornImageView.image = #imageLiteral(resourceName: "unicorn")
        addedBy.text = "Added by"
        seenAt.text = "Seen at"
    }
}
