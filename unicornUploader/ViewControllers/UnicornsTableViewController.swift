//
//  UnicornsTableViewController.swift
//  unicornUploader
//
//  Created by Deyan Aleksandrov on 31.03.18.
//  Copyright © 2018 dido. All rights reserved.
//

import UIKit

class UnicornsTableViewController: UITableViewController {

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
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unicornTableViewCell", for: indexPath)
        // Configure the cell...
        return cell
    }
}
