//
//  SearchGroupViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/10/24.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class SearchGroupViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var table: UITableView!
    var searchBar = UISearchBar()
    var searchContrller = UISearchController()
    
    var numberArray = [0, 1, 2, 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        
        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return numberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableCell") as! GroupTableCell
        cell.searchlabel.text = numberArray[indexPath.row]
    }
    
    @IBAction func ok() {
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
