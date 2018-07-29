//
//  AllListViewController.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 25/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController, AddListControllerDelegate, UINavigationControllerDelegate {
    var dataModel: DataModel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = UserDefaults.standard.integer(forKey: Constants.UserDefaultKeys.checkListIndex)
        if (index != 0){
            let checkList = dataModel.lists[index - 1]
            performSegue(withIdentifier: Constants.SegueIdentifiers.showChecklist, sender: checkList)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataModel.lists.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = dataModel.lists[indexPath.row]
        let cellIdentifier = Constants.CellIdentifiers.allListTableViewCell
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.accessoryType = .detailDisclosureButton
        configureLabelForCell(cell: cell, forList: list)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths as [IndexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = dataModel.lists[indexPath.row]
        // if the key is not found it returns 0 so we start indexing by 1
        UserDefaults.standard.set(indexPath.row + 1, forKey: Constants.UserDefaultKeys.checkListIndex)
        performSegue(withIdentifier: Constants.SegueIdentifiers.showChecklist, sender: list)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIds.addListNavigationController) as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.listToEdit = dataModel.lists[indexPath.row]
        controller.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            UserDefaults.standard.set(0, forKey: Constants.UserDefaultKeys.checkListIndex)
        }
    }
    
    func addListControllerDidCancel(controller: ListDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addListController(controller: ListDetailViewController, didFinishAddingList list: List) {
        let index = dataModel.lists.count
        dataModel.lists.append(list)
        let indexPath = NSIndexPath(row: index, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addListController(controller: ListDetailViewController, didFinishEditingList list: List) {
        if let index = dataModel.lists.index(where: {$0 === list}){
            let indexPath = NSIndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath as IndexPath){
                configureLabelForCell(cell: cell, forList: list)
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.showChecklist{
            let checklistVC = segue.destination as! CheckListController
            checklistVC.checkList = sender as? List
        } else if segue.identifier == Constants.SegueIdentifiers.addChecklist{
            let navigationController = segue.destination as! UINavigationController
            let addListVC = navigationController.topViewController as! ListDetailViewController
            addListVC.delegate = self
        }
    }
    
    // Put the list name into the label field.
    func configureLabelForCell(cell: UITableViewCell, forList list:List){
        cell.textLabel?.text = list.name
    }
}
