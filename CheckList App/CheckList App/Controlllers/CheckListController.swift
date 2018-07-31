//
//  ViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 21/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class CheckListController: UITableViewController, AddItemControllerDelegate {
    var checkList: List!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checkList?.name
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.checklistitem) as! UITableViewCell
        let item = checkList.items[indexPath.row]
        configureLabelForCell(cell: cell, forItem: item)
        configureCheckmarkForCell(cell: cell, forItem: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let item = checkList.items[indexPath.row]
        item.toggleChecked()
        configureCheckmarkForCell(cell: cell!, forItem: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checkList.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func addItemControllerDidCancel(controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemController(controller: ItemDetailViewController, didFinishAddingItem item: Item) {
        item.scheduleNotification(forList: checkList)
        checkList.items.append(item)
        checkList.sortCheckListItems()
        tableView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemController(controller: ItemDetailViewController, didFinishEditingItem item: Item) {
        item.scheduleNotification(forList: checkList)
        checkList.sortCheckListItems()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.addItem{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == Constants.SegueIdentifiers.editItem{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }

    func configureCheckmarkForCell(cell:UITableViewCell,forItem item: Item){
        let label = cell.viewWithTag(Constants.ViewTags.checkMarkItemLabelTag) as! UILabel
        if item.isChecked!{
            label.text = Constants.SpecialSymbols.checkMark
            label.textColor = view.tintColor
        }else{
            label.text = ""
        }
    }
    
    func configureLabelForCell(cell:UITableViewCell,forItem item: Item){
        let label = cell.viewWithTag(Constants.ViewTags.checkListItemLabelTag) as! UILabel
        label.text = item.name
        
        let subtitleLabel = cell.viewWithTag(Constants.ViewTags.checkListItemSubtitleLabelTag) as! UILabel
        let date = item.dueDate as Date
        subtitleLabel.text = date.formatInString()
    }
    
    
    func addNewItem(name: String , isChecked: Bool){
        let newItem = Item()
        newItem.name = name
        newItem.isChecked = isChecked
        checkList.items.append(newItem)
    }
    
}
