//
//  IconPickerViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 29/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerControllerDelegate?

    let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Choose Icon"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let icon = icons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.iconPickerCell) as! UITableViewCell
        cell.imageView?.image = UIImage(named: icon)
        cell.textLabel?.text = icon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPicker(picker: self, didPickIcon: icons[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

protocol IconPickerControllerDelegate: class {
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName:String)
}
