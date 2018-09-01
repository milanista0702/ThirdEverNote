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
    
    @IBOutlet var grouplabel: UILabel!
    var userArray = [MiddleGroup]()
    var todoArray = [MiddleGTS]()
    var groupname: String?
    
    let titleArray : Array = ["User", "Todo & Schedule"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let table: UITableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableCell")
        
        self.view.addSubview(table)
        
        MiddleGroup.loadall2(mygroup: "groupname", callback: {objects in
            self.userArray.removeAll()
            for object in objects {
                self.userArray.append(object)
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
        return titleArray[section] as String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userArray.count
        } else if section == 1 {
            return todoArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(userArray[indexPath.row])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(todoArray[indexPath.row])"
        }
        return cell
    }
    
}
