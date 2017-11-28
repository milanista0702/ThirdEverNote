//
//  SearchGroupViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/10/24.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class SearchGroupViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var searchBar = UISearchBar()
    var searchContrller = UISearchController()
    
    var numberArray = ["0", "1", "2", "3"]
    
    let saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        
        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return numberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!GroupTableViewCell
        cell.searchlabel.text = numberArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView:UITableView, didSelecRowAt indexPath: IndexPath) {
        NSLog("%@が選択された", numberArray[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) as! GroupTableViewCell
    }
    
    @IBAction func ok() {
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
