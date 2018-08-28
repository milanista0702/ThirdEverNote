//
//  MyAccountViewController.swift
//  ThirdEverNote
//
//  Created by misako makka on 2018/07/03.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class MyAccountViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mylabel: UILabel!
    @IBOutlet var userlabel: UILabel!
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var groupslabel: UILabel!
    @IBOutlet var table: UITableView!
    var groupsArray = [MiddleGroup]()
    
    let saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTabelCell")
        
        MiddleGroup.loadall(callback: {objects in
            self.groupsArray.removeAll()
            for object in objects {
                self.groupsArray.append(object)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as!GroupTableViewCell
        cell.searchlabel.text = String(groupsArray[indexPath.row].group.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        //        ここ！！！！！！！！！　次の画面に進むやで！！！
    }
    
    @IBAction func signoutbutton() {
        
    }
    
    @IBAction func back(sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
