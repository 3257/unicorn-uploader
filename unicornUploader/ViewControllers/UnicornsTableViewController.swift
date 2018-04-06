//
//  UnicornsTableViewController.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class UnicornsTableViewController: UITableViewController {

    // MARK: - Variables
    var ref: DatabaseReference!
    var firebaseHandle: UInt!
    
    var unicorns = [Unicorn]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Hide separators for empty cells
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseHandle = ref.child("unicorns").observe(.value) { snapshot in
            var unicorns = [Unicorn]()
            for unicornSnapshot in snapshot.children {
                let unicorn = Unicorn(snapshot: unicornSnapshot as! DataSnapshot)
                unicorns.append(unicorn)
            }
            self.unicorns = unicorns
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeObserver(withHandle: firebaseHandle)
    }
}

// MARK: - Table view data source
extension UnicornsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unicorns.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unicornTableViewCell", for: indexPath) as! UnicornTableViewCell
        cell.unicorn = unicorns[indexPath.row]
        return cell
    }
}
