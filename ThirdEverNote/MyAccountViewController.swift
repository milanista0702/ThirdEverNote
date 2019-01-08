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
    var mygroup : Group?
    var groupid: String?
    var myuser: NCMBUser?
    
    
    let saveData: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        namelabel.text = NCMBUser.current().userName
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        table.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableViewCell")
        
        MiddleGroup.loadall(callback: {objects in
            self.groupsArray.removeAll()
            for object in objects {
                self.groupsArray.append(object)
                print(object.user.objectId)
            }
            self.table.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mygroupsegue"{
            let VRT = segue.destination as! GroupViewController
            VRT.user = myuser
            VRT.groupname = mygroup
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        print(groupsArray[indexPath.row].group.object(forKey: "objectId") as! String)
        groupid = groupsArray[indexPath.row].group.objectId
        Group.getName(id: groupid!, callback:{ objects in
            DispatchQueue.main.async {
                cell.searchlabel.text = objects[0].name
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath)
        _ = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        mygroup = groupsArray[indexPath.row].group
        myuser = groupsArray[indexPath.row].user 
        performSegue(withIdentifier: "mygroupsegue", sender: nil)
    }
    
    @IBAction func signoutbutton() {
        let alert = UIAlertController(title: "SignOut", message: "Would you like to Signout?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "0K", style: .default){ _ in
            NCMBUser.logOut()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
