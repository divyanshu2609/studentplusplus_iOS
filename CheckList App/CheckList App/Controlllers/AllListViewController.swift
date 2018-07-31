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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedCheckList
        if (index >= 0 && index < dataModel.lists.count){
            let checkList = dataModel.lists[index]
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
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        configureItemDoneLabelForCell(cell: cell, forList: list)
        configureLabelForCell(cell: cell, forList: list)
        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = UIImage(named: list.iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = dataModel.lists[indexPath.row]
        dataModel.indexOfSelectedCheckList = indexPath.row
        // sender of the segue is received in the function prepare for segue.
        performSegue(withIdentifier: Constants.SegueIdentifiers.showChecklist, sender: list)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardIds.addListNavigationController) as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.listToEdit = dataModel.lists[indexPath.row]
        controller.delegate = self
        // present is used to add another Controller above the main Controller. Like present modally of segue.
        present(navigationController, animated: true, completion: nil)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self{
            // indexofSelectedChecklist indicates whether the user was on the main screen or on a Item screen, holds the row number of lists. If -1 means home screen, else listItem screen.
            dataModel.indexOfSelectedCheckList = -1
        }
    }
    
    func addListControllerDidCancel(controller: ListDetailViewController) {
        // dismiss is used when controller is embedded in different view controller which was presented modally
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addListController(controller: ListDetailViewController, didFinishAddingList list: List) {
        dataModel.lists.append(list)
        dataModel.sortCheckLists()
        tableView.reloadData()
        // dismiss is used when controller is embedded in different view controller which was presented modally
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addListController(controller: ListDetailViewController, didFinishEditingList list: List) {
        dataModel.sortCheckLists()
        tableView.reloadData()
        // dismiss is used when controller is embedded in different view controller which was presented modally
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.showChecklist{
            // segue for ChecklistItem Screen
            let checklistVC = segue.destination as! CheckListController
            checklistVC.checkList = sender as? List
        } else if segue.identifier == Constants.SegueIdentifiers.addChecklist{
            // segue for Add list screen
            let navigationController = segue.destination as! UINavigationController
            let addListVC = navigationController.topViewController as! ListDetailViewController
            addListVC.delegate = self
        }
    }
    
    // Put the list name into the label field.
    func configureLabelForCell(cell: UITableViewCell, forList list:List){
        cell.textLabel?.text = list.name
    }
    
    // configure the subtitle field of AllLists
    func configureItemDoneLabelForCell(cell: UITableViewCell, forList list:List){
        let countUncheckedItems = list.countUncheckedItems()
        if list.items.count == 0{
            cell.detailTextLabel?.text = "(No items)"
        } else if countUncheckedItems == 0{
            cell.detailTextLabel?.text = "All done!"
        } else {
            cell.detailTextLabel?.text = "\(countUncheckedItems) Remaining"
        }
    }
}
