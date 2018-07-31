//
//  ListDetailViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 26/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerControllerDelegate{
   
    var iconName = "Folder"
    weak var delegate: AddListControllerDelegate?
    var listToEdit: List?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        if let list = listToEdit{
            title = "Edit List"
            nameTextField.text = list.name
            iconName = list.iconName
            doneBarButton.isEnabled = true
        } else {
            title = "Add List"
            doneBarButton.isEnabled = false
        }
        
        iconImageView.image = UIImage(named: iconName)
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
            list.iconName = iconName
            delegate?.addListController(controller: self, didFinishEditingList: list)
        }else{
            let list = List(name: nameTextField.text!, iconName: iconName)
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
        if indexPath.section == 1{
            return indexPath
        } else{
            return nil
        }
    }
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let pickIconController = segue.destination as! IconPickerViewController
            pickIconController.delegate = self
        }
    }
}

protocol AddListControllerDelegate: class{
    func addListControllerDidCancel(controller: ListDetailViewController)
    func addListController(controller: ListDetailViewController, didFinishAddingList list: List)
    func addListController(controller: ListDetailViewController, didFinishEditingList list: List)
}

