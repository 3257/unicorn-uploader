//
//  UnicornTableViewCell.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit

class UnicornTableViewCell: UITableViewCell {

    @IBOutlet weak var unicornImageView: UIImageView!
    @IBOutlet weak var addedBy: UILabel!
    @IBOutlet weak var seenAt: UILabel!

    var unicorn: Unicorn? {
        didSet {
            if let unicorn = unicorn {
                // TODO: Implement image update
                // unicornImageView.image =
                addedBy.text = unicorn.addedBy
                seenAt.text = unicorn.seenAt
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        unicornImageView.image = #imageLiteral(resourceName: "unicorn")
        addedBy.text = "Added by"
        seenAt.text = "Seen at"
    }
}
