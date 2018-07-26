//
//  ViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 21/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class CheckListController: UITableViewController, AddItemControllerDelegate {
    var items : [Item]
    var checkList: List?
    
    required init?(coder aDecoder: NSCoder) {
        items = [Item]()
        super.init(coder: aDecoder)
        loadingCheckListItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checkList?.name
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistitem") as! UITableViewCell
        let item = items[indexPath.row]
        configureLabelForCell(cell: cell, forItem: item)
        configureCheckmarkForCell(cell: cell, forItem: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let item = items[indexPath.row]
        item.toggleChecked()
        configureCheckmarkForCell(cell: cell!, forItem: item)
        saveCheckListItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveCheckListItem()
    }
    
    func addItemControllerDidCancel(controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemController(controller: ItemDetailViewController, didFinishAddingItem item: Item) {
        let itemsCount = items.count
        items.append(item)
        let indexPath = NSIndexPath(row: itemsCount, section: 0)
        let insertPaths = [indexPath]
        tableView.insertRows(at: insertPaths as [IndexPath], with: .automatic)
        saveCheckListItem()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemController(controller: ItemDetailViewController, didFinishEditingItem item: Item) {
        if let index = items.index(where: {$0 === item}){
            let indexPath = NSIndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath as IndexPath){
                configureLabelForCell(cell: cell, forItem: item)
            }
        }
        saveCheckListItem()
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }

    func configureCheckmarkForCell(cell:UITableViewCell,forItem item: Item){
        let label = cell.viewWithTag(101) as! UILabel
        if item.isChecked!{
            label.text = "✔︎"
        }else{
            label.text = ""
        }
    }
    
    func configureLabelForCell(cell:UITableViewCell,forItem item: Item){
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.name
    }
    
    
    func addNewItem(name: String , isChecked: Bool){
        let newItem = Item()
        newItem.name = name
        newItem.isChecked = isChecked
        items.append(newItem)
    }
    
    func documentDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentDirectory().stringByAppendingPathComponent(path: "CheckList.plist")
    }
    
    func saveCheckListItem(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "CheckListItems")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadingCheckListItems(){
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                items = unarchiver.decodeObject(forKey: "CheckListItems") as! [Item]
                unarchiver.finishDecoding()
            }
        }
    }
}
