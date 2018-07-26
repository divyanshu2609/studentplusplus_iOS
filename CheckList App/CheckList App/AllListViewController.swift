//
//  AllListViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 25/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController, AddListControllerDelegate {
    
    var lists : [List]
    
    required init?(coder aDecoder: NSCoder) {
        lists = [List]()
        
        var list = List(name: "Birthdays")
        lists.append(list)
        
        list = List(name: "Groceries")
        lists.append(list)
        
        list = List(name: "To Do")
        lists.append(list)
        
        list = List(name: "Meetings")
        lists.append(list)
        
        super.init(coder: aDecoder)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lists.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = lists[indexPath.row]
        let cellIdentifier = "cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.accessoryType = .detailDisclosureButton
        configureLabelForCell(cell: cell, forList: list)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths as [IndexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.row]
        performSegue(withIdentifier: "showChecklist", sender: list)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddListNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.listToEdit = lists[indexPath.row]
        controller.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
    
    func addListControllerDidCancel(controller: ListDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addListController(controller: ListDetailViewController, didFinishAddingList list: List) {
        let index = lists.count
        lists.append(list)
        let indexPath = NSIndexPath(row: index, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addListController(controller: ListDetailViewController, didFinishEditingList list: List) {
        if let index = lists.index(where: {$0 === list}){
            let indexPath = NSIndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath as IndexPath){
                configureLabelForCell(cell: cell, forList: list)
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChecklist"{
            let checklistVC = segue.destination as! CheckListController
            checklistVC.checkList = sender as? List
        } else if segue.identifier == "AddList"{
            let navigationController = segue.destination as! UINavigationController
            let addListVC = navigationController.topViewController as! ListDetailViewController
            addListVC.delegate = self
        }
    }
    
    func configureLabelForCell(cell: UITableViewCell, forList list:List){
        cell.textLabel?.text = list.name
    }
 
}
