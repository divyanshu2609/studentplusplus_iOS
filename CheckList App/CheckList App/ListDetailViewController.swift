//
//  ListDetailViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 26/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class ListDetailViewController: UITableViewController, UITextFieldDelegate{
    weak var delegate: AddListControllerDelegate?
    var listToEdit: List?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        if let list = listToEdit{
            title = "Edit List"
            nameTextField.text = list.name
            doneBarButton.isEnabled = true
        } else {
            title = "Add List"
            doneBarButton.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.addListControllerDidCancel(controller: self)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let list = listToEdit{
            list.name = nameTextField.text!
            delegate?.addListController(controller: self, didFinishEditingList: list)
        }else{
            let list = List(name: nameTextField.text!)
            delegate?.addListController(controller: self, didFinishAddingList: list)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = newText.length > 0
        return true
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.resignFirstResponder()
    }
}

protocol AddListControllerDelegate: class{
    func addListControllerDidCancel(controller: ListDetailViewController)
    func addListController(controller: ListDetailViewController, didFinishAddingList list: List)
    func addListController(controller: ListDetailViewController, didFinishEditingList list: List)
}

