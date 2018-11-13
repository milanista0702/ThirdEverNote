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
    @IBOutlet var memberlabel: UILabel!
    var text: String?
    var ttext: String?
    var stext: String?
    var schedule: String?
    var todo: String?
    var memberArray = [NCMBUser]()
    var groupcreate: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        memberlabel.backgroundColor = UIColor.black
        memberlabel.textColor = UIColor.white
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "totodo" {
            let VT = segue.destination as! AddViewController
            VT.groupcreates = groupcreate
        }else{
            let VS = segue.destination as! ScheduleAddViewController
            VS.groupcreates = groupcreate
        }
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
        print(memberArray)
        Group.saveWithEvent(name: groupcreate!, callBack: {
            for element in self.memberArray {
                let middlegroup = MiddleGroup.create(group: self.groupcreate!, user: element)
                MiddleGroup.saveWithEvent(group: middlegroup, callBack: {
                })
            }
        })
        
        //2個前のAddViewControllernへのSegueがわり
        let prepareVC = presentingViewController?.presentingViewController as? AddViewController
        prepareVC?.membersArray = self.memberArray
        
        let def = UserDefaults.standard

        let screenback: Bool = def.bool(forKey: "addtrue")
        if screenback == true {
            performSegue(withIdentifier: "totodo", sender: nil)
        }else{
            performSegue(withIdentifier: "toschedule", sender: nil)
        }
        
    }
    
    
    @IBAction func back()  {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
