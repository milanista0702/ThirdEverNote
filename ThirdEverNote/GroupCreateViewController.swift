//
//  GroupCreateViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/10/17.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class GroupCreateViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var text: UITextField!
    @IBOutlet var table: UITableView!

    
    @IBOutlet var createlabel: UILabel!
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var memberlabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        
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
    
    @IBAction func ok() {

    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
