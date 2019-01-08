//
//  SearchGroupViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/10/24.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class SearchGroupViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    
    @IBOutlet var table: UITableView!
    var searchController = UISearchController()
    var groupArray = [MiddleGroup]()
    var addgroupArray = [Group]()
    var groups: Group?
    var groupid: String?
    
    @IBOutlet var groupsearchlabel: UILabel!
    
    let saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
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
        
        MiddleGroup.loadall(callback: {objects in
            self.groupArray.removeAll()
            for object in objects {
                self.groupArray.append(object)
            }
            self.table.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let GVC = segue.destination as! AddViewController
        GVC.exgroupArray = addgroupArray
    }
    func updateSearchResults(for searchController: UISearchController) {
        groupArray = []
        let searchBarText = searchController.searchBar.text!.lowercased()
        let query = MiddleGroup.query()
        query?.findObjectsInBackground({objects, error in
            if error != nil {
                print("Group取得失敗")
            }else{
                let middleGroups = objects as! [MiddleGroup]
                for i in 0..<middleGroups.count {
                    let middleGroup = middleGroups[i]
                    let groupNCMBObject = middleGroup.object(forKey: "group") as! NCMBObject
                    Group.getName(id: groupNCMBObject.object(forKey: "objectId") as! String, callback: { objects in DispatchQueue.main.async {
                        var groupName = objects[0].name as! String
                        groupName = groupName.lowercased()
                        if groupName.contains(searchBarText) {
                            print("一致した")
                            self.groupArray.append(middleGroup)
                            self.table.reloadData()
                        }else{
                            print("不一致")
                        }
                        }}
                    )
                }
            }
        })
    }
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as!GroupTableViewCell
        groupid = groupArray[indexPath.row].group.objectId
        Group.getName(id: groupid!, callback: { objects in DispatchQueue.main.async {
            cell.searchlabel.text = objects[0].name
            }
        })
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
        cell.accessoryType = .checkmark
        Group.search(name: cell.searchlabel.text!, callback: {objects in
            for object in objects {
                self.addgroupArray.append(object)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        groupArray.remove(at: indexPath.row)
    }
    
    @IBAction func ok(sender: UIButton) {
       self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        self.groupArray.removeAll()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
