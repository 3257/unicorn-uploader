//
//  Unicorn.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Unicorn {
    let imagePath: String
    let addedBy: String
    let seenAt: String

    // Standard init
    init(imagePath: String, addedBy: String, seenAt: String) {
        self.imagePath = imagePath
        self.addedBy = addedBy
        self.seenAt = seenAt
    }

    // Init for reading from Database snapshot
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        imagePath = snapshotValue["imagePath"] as! String
        addedBy = snapshotValue["addedBy"] as! String
        seenAt = snapshotValue["seenAt"] as! String
    }

    // Func converting model for easier writing to database
    func toAnyObject() -> Any {
        return [
            "imagePath": imagePath,
            "addedBy": addedBy,
            "seenAt": seenAt
        ]
    }
}
