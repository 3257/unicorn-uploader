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
    let key: String
    let ref: DatabaseReference?
    let imagePath: String
    let addedBy: String
    let seenAt: String

    init(key: String = "", ref: DatabaseReference? = nil, imagePath: String, addedBy: String, seenAt: String) {
        self.key = key
        self.ref = ref
        self.imagePath = imagePath
        self.addedBy = addedBy
        self.seenAt = seenAt
    }

    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref

        let snapshotValue = snapshot.value as! [String: AnyObject]
        imagePath = snapshotValue["imagePath"] as! String
        addedBy = snapshotValue["addedBy"] as! String
        seenAt = snapshotValue["seenAt"] as! String
    }

    func toAnyObject() -> Any {
        return [
            "imagePath": imagePath,
            "addedBy": addedBy,
            "seenAt": seenAt
        ]
    }
}
