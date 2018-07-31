//
//  AddListController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 21/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    weak var delegate: AddItemControllerDelegate?
    var itemToEdit: Item?
    var dueDate = NSDate()
    var datePickerVisible = false

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var remindMeSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameTextField.delegate = self
        
        if let item = itemToEdit {
            title = "Edit List"
            itemNameTextField.text = item.name
            remindMeSwitch.isOn = item.shouldRemind!
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard itemToEdit != nil else {
            doneBarButton.isEnabled = false
            return
        }
        itemNameTextField.becomeFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2{
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible{
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.datePickerCell) as? UITableViewCell
            if cell == nil{
                cell = UITableViewCell(style: .default, reuseIdentifier: Constants.CellIdentifiers.datePickerCell)
                cell?.selectionStyle = .none
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = Constants.ViewTags.datePickerTag
                cell?.contentView.addSubview(datePicker)
                datePicker.addTarget(self, action: #selector(dueDateChanged(_:)), for: .valueChanged)
            }
            return cell!
        } else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemNameTextField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1{
            if !datePickerVisible{
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }
        else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var indexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            indexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if let item = itemToEdit{
            item.name = itemNameTextField.text
            item.shouldRemind = remindMeSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemController(controller: self, didFinishEditingItem: item)
        } else {
            let item = Item()
            item.name = itemNameTextField.text
            item.isChecked = false
            item.shouldRemind = remindMeSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemController(controller: self, didFinishAddingItem: item)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.addItemControllerDidCancel(controller: self)
    }
    
    @IBAction func shouldRemindToggled(_ sender: UISwitch) {
        if sender.isOn{
            UserNotificationHandler.registerAuthorization()
        }
    }
    
    
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate as Date)
    }
    
    func showDatePicker(){
        datePickerVisible = true
        let indexPathDateRow = NSIndexPath(row: 1, section: 1)
        let indexPathDatePicker = NSIndexPath(row: 2, section: 1)
        if let dateCell = tableView.cellForRow(at: indexPathDateRow as IndexPath){
            dateCell.detailTextLabel?.textColor = dateCell.detailTextLabel?.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker as IndexPath], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow as IndexPath], with: .none)
        tableView.endUpdates()
        if let pickekCell = tableView.cellForRow(at: indexPathDatePicker as IndexPath){
            let datePicker = pickekCell.viewWithTag(Constants.ViewTags.datePickerTag) as! UIDatePicker
            datePicker.setDate(dueDate as Date, animated: false)
        }
    }
    
    func hideDatePicker(){
        if datePickerVisible{
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(row: 1, section: 1)
            let indexPathDatePicker = NSIndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow as IndexPath){
                cell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow as IndexPath], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker as IndexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    @objc func dueDateChanged(_ datePicker: UIDatePicker){
        dueDate = datePicker.date as NSDate
        updateDueDateLabel()
    }
}


protocol AddItemControllerDelegate: class {
    func addItemControllerDidCancel(controller: ItemDetailViewController)
    func addItemController(controller: ItemDetailViewController, didFinishAddingItem item: Item)
    func addItemController(controller: ItemDetailViewController, didFinishEditingItem item: Item)
}
