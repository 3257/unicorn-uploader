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

    func downloadImage(from storagePath: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        guard let fileURL = URL(string: filePath) else { return }

        // Start download of image
        storageDownloadTask = storageRef.child(storagePath).write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                return
            } else if let imagePath = url?.path {
                self.unicornImageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
        // Finish download of image
    }

    override func awakeFromNib() {
        storageRef = Storage.storage().reference()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        unicornImageView.image = #imageLiteral(resourceName: "unicorn")
        addedBy.text = "Added by"
        seenAt.text = "Seen at"
        storageDownloadTask.cancel()
    }
}
