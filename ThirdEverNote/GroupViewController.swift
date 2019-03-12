//
//  GroupViewController.swift
//  ThirdEverNote
//
//  Created by misako makka on 2018/08/28.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var grouplabel: UILabel!
    var userArray = [MiddleGroup]()
    var todoArray = [MiddleGTS]()
    var userNameArray = [String]()
    var todoNameArray = [String]()
    var groupname: Group?
    var user: NCMBUser?
    var userName: String = ""
    
    let titleArray : Array = ["User", "Todo & Schedule"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        
        table.dataSource = self
        table.delegate = self
        
        //self.view.addSubview(table)
        
//        MiddleGroup.loadall2(mygroup: groupname!, callback: {objects in
//            self.userArray.removeAll()
//            for object in objects {
//                self.userArray.append(object)
//            }
//            
//            MiddleGroup.userGetName(objetct: self.userArray[0])
//            
//            
//            self.table.reloadData()
//        })
        
        MiddleGroup.loadall2(mygroup: groupname!, callback: {objects in
            self.userArray.removeAll()
            for object in objects {
                self.userArray.append(object)
            }
            for i in self.userArray {
                MiddleGroup.userGetName(object: i, callback: { objects in DispatchQueue.main.async {
                    if objects != nil {
                        self.userNameArray.append(objects[0])
                    }
                    self.table.reloadData()
                    }})
            }
        })
        
       
        
        
        Group.getName(id: (groupname?.objectId)!, callback: {objects in
            DispatchQueue.main.async {
                self.grouplabel.text = objects[0].name
            }
        })
        NCMBUser.getName(id: (user?.objectId)! , callback: {objets in
            DispatchQueue.main.async {
                self.userName = objets[0].userName
                self.table.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArray[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userNameArray.count
        } else if section == 1 {
            return todoArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        if indexPath.section == 0 {
//            cell.searchlabel.text = userArray[indexPath.row].user.userName
            cell.searchlabel.text = userNameArray[indexPath.row]

        } else if indexPath.section == 1 {
            cell.searchlabel.text = todoArray[indexPath.row].Todo?.todo
        }
        return cell
    }
    
    @IBAction func back(sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tocalender(sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
