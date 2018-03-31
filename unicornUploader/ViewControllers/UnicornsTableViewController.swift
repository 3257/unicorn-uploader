//
//  UnicornsTableViewController.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit

class UnicornsTableViewController: UITableViewController {

    // MARK: - Variables
    var unicorns = [Unicorn]() {
        didSet {
            tableView.reloadData()
        }
    }


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
