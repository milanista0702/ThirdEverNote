//
//  GroupVerificationViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2018/01/23.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class GroupVerificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var mtable: UITableView!
    @IBOutlet var utable: UITableView!
    @IBOutlet var label: UILabel!
    var text: String?
    var ttext: String?
    var stext: String?
    var schedule: String?
    var todo: String?
    var memberArray = [NCMBUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = text
        
        mtable.delegate = self
        mtable.dataSource = self
        
        utable.delegate = self
        utable.dataSource = self
        
        self.mtable.estimatedRowHeight = 90
        self.mtable.rowHeight = UITableViewAutomaticDimension
        self.utable.estimatedRowHeight = 90
        self.utable.rowHeight = UITableViewAutomaticDimension
        
        mtable.register(UINib(nibName:"GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        utable.register(UINib(nibName:"GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == mtable {
            return memberArray.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as!GroupTableViewCell
        if tableView == mtable {
            cell.searchlabel.text = memberArray[indexPath.row].userName
        }else{
            if stext == nil {
                cell.searchlabel.text = ttext
            }else{
                cell.searchlabel.text = stext
            }
            
        }
        return cell
    }
    
    
    @IBAction func ok() {
        self.performSegue(withIdentifier: "view", sender: nil)
    }
    
    
    @IBAction func back()  {
        self.dismiss(animated: true, completion: nil)
    }
    
}
