//
//  GroupCreateViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/10/17.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class GroupCreateViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet var text: UITextField!
    @IBOutlet var table: UITableView!
    var searchController = UISearchController()
    
    var userArray = [NCMBUser]()
    
    @IBOutlet var createlabel: UILabel!
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var memberlabel: UILabel!
    
    let saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        table.delegate = self
        table.dataSource = self
        searchController.delegate = self
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        table.register(UINib(nibName:"GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        
        self.view.addSubview(table)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        table.tableHeaderView = searchController.searchBar
        
        createlabel.backgroundColor = ColorManager.navy
        createlabel.textColor = UIColor.white
        namelabel.backgroundColor = ColorManager.navy
        namelabel.textColor = UIColor.white
        memberlabel.backgroundColor = ColorManager.navy
        memberlabel.textColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!GroupTableViewCell
        cell.searchlabel.text = String(userArray[indexPath.row].userName)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = NCMBUser.query()
        // TODO: .text!の!を安全にアンラップ
        query?.whereKey("userName", equalTo: searchController.searchBar.text!)
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil) {
                print(error)
            }else{
                print("objects ... \(objects)")
                self.userArray =  objects as! [NCMBUser]
                self.table.reloadData()
            }
        })
    }
    
    
    @IBAction func ok() {
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupCreateViewController : UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}
