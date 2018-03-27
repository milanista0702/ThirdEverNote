//
//  SearchGroupViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/10/24.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class SearchGroupViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var table: UITableView!
    var searchController = UISearchController()
    var groupArray = [Group]()
    var addgroupArray = [Group]()
    var groups: Group?
    
    @IBOutlet var groupsearchlabel: UILabel!
    
    let saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        searchController.delegate = (self as! UISearchControllerDelegate)
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        
        self.view.addSubview(table)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        table.tableHeaderView = searchController.searchBar
        
        groupsearchlabel.backgroundColor = UIColor.black
        groupsearchlabel.textColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func updateSearchResults(for searchContrller: UISearchController) {
        let query = Group.query()
        query?.whereKey("name", equalTo: searchController.searchBar.text!)
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil) {
                print(error as Any)
            }else{
                print("objects ... \(String(describing: objects))")
                self.groupArray = objects as! [Group]
                self.table.reloadData()
            }
        })
    }
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!GroupTableViewCell
        cell.searchlabel.text = String(groupArray[indexPath.row].name)
        cell.accessoryType = .none
        return cell
    }
    
    @nonobjc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        addgroupArray.append(groupArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        addgroupArray.remove(at: indexPath.row)
    }
    
    @IBAction func ok(sender: UIButton) {
//        let middlegroup = MiddleGroup.create(group: groups!, user: element)
//        MiddleGroup.saveWithEvent(group: middlegroup, callBack: {
//            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        })
//        addgroupArray.addgroupArray.append(at: IndexPath.row)
//        addgroupArray.remove(at: IndexPath.)
    }
    
    @IBAction func cancel() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
