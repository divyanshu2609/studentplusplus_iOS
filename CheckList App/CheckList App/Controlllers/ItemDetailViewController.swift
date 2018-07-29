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

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var itemNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameTextField.delegate = self
        
        if let item = itemToEdit {
            title = "Edit List"
            itemNameTextField.text = item.name
        }
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
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if let item = itemToEdit{
            item.name = itemNameTextField.text
            delegate?.addItemController(controller: self, didFinishEditingItem: item)
        } else {
            let item = Item()
            item.name = itemNameTextField.text
            item.isChecked = false
            delegate?.addItemController(controller: self, didFinishAddingItem: item)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.addItemControllerDidCancel(controller: self)
    }
}


protocol AddItemControllerDelegate: class {
    func addItemControllerDidCancel(controller: ItemDetailViewController)
    func addItemController(controller: ItemDetailViewController, didFinishAddingItem item: Item)
    func addItemController(controller: ItemDetailViewController, didFinishEditingItem item: Item)
}
