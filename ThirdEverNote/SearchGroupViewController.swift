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
    
    var numberArray = ["0", "1", "2", "3"]
    var searchResults : [String] = []
    
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchController.isActive {
            return searchResults.count
        }else{
            return numberArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!GroupTableViewCell
        if searchController.isActive{
            cell.searchlabel.text = searchResults[indexPath.row]
        }else{
            cell.searchlabel.text = numberArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    
    func tableView(_ tableView:UITableView, didSelecRowAt indexPath: IndexPath) {
        NSLog("%@が選択された", numberArray[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchResults = numberArray.filter{
            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        self.table.reloadData()
    }
    
    @IBAction func ok() {
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
