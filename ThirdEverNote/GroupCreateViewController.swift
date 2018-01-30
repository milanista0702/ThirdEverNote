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
    
    var membersArray = [NCMBUser]()
    var usersArray = [NCMBUser](){
        didSet{
            membersArray = usersArray
        }
    }
    
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
        table.allowsMultipleSelection = true
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        var GroupVerificationViewController = segue.destination as! GroupVerificationViewController
        GroupVerificationViewController.text = self.text.text
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        membersArray.append(usersArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        membersArray.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!GroupTableViewCell
        cell.searchlabel.text = String(usersArray[indexPath.row].userName)
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
                self.usersArray =  objects as! [NCMBUser]
                self.table.reloadData()
            }
        })
    }
    
    
    @IBAction func ok(sender: UIButton) {
        self.performSegue(withIdentifier: "ToVerificationsegue", sender: nil)
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
