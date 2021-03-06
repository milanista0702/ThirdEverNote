//
//  ScheduleAddViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/06/20.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class ScheduleAddViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var text: UITextField!
    @IBOutlet var date: UIDatePicker!
    @IBOutlet var shareswitch: UISwitch!
    @IBOutlet var addlabel: UILabel!
    @IBOutlet var schedulelabel: UILabel!
    @IBOutlet var daylabel: UILabel!
    @IBOutlet var sharelabel: UILabel!
    
    var schedule: Schedule!
    
    var membersArray = [NCMBUser]() //from cratenewgroup
    
    var groupcreates : Group?
    
    var schefromcrate : Bool!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        
        addlabel.backgroundColor = ColorManager.orange
        addlabel.textColor = UIColor.white
        schedulelabel.backgroundColor = ColorManager.orange
        schedulelabel.textColor = UIColor.white
        daylabel.backgroundColor = ColorManager.orange
        daylabel.textColor = UIColor.white
        sharelabel.backgroundColor = ColorManager.orange
        sharelabel.textColor = UIColor.white
        
        shareswitch.isOn = false
        shareswitch.addTarget(self, action: #selector(ScheduleAddViewController.onClick(sender:)), for: .valueChanged)
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
//        if segue.identifier == "schenewsegue"{
//            let VRT = segue.destination as! GroupCreateViewController
//            VRT.scheduletext = self.text.text
////            VRT.completions = { group in
////                self.groupcreates = group
////            }
//        }
//    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    @objc func onClick (sender: UISwitch) {
        if sender.isOn {
            self.showalert()
        }else{
        }
    }
    
    func showalert() {
        let alert = UIAlertController(title: "Group", message: "Create a NewGroup\nor\nExisting Group", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Create a New Group", style: .default) { _ in
            self.performSegue(withIdentifier: "schenewsegue", sender: nil)
        }
        let action2 = UIAlertAction(title: "Existing Group", style: .default) { _ in
            self.performSegue(withIdentifier: "schesearch", sender: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func ok(sender: UIButton) {
        if text.text?.isEmpty == true{
                let alert = UIAlertController(title: "Inadequate", message: "write Schedule", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        }else{
            if shareswitch.isOn == true {
                
                //from create
                if schefromcrate == true {
                    for element in self.membersArray {
                        schedule = Schedule.create(title: text.text!, user: element, isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                        Schedule.saveWithEvent(schedule: schedule, callBack: saveGTS)
                    }
                }else{
                    //from existing
                    for element in self.membersArray{
                        let schedule = Schedule.create(title: text.text!, user: element, isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                        Schedule.saveWithEvent(schedule: schedule, callBack: {})
                    }
                }
                
                self.dismiss(animated: true, completion: nil)
                
            }else{
                let schedule = Schedule.create(title: text.text!, user: NCMBUser.current(), isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                Schedule.saveWithEvent(schedule: schedule, callBack: {})
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func saveGTS() {
        let GTS = MiddleGTS.create(Todo: nil, Schedule: schedule, group: groupcreates!)
        MiddleGTS.saveWithEvent(group: GTS, callBack: {})
    }
    
    @IBAction func cancel () {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "schenewsegue" {
            let GroupCreateViewCOntrollerTwo = segue.destination as! GroupCreateViewController
            GroupCreateViewCOntrollerTwo.scheduletext = sender as? String
        }
    }
    
    // ---- UIViewControllerTransitioningDelegate methods
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }
}
