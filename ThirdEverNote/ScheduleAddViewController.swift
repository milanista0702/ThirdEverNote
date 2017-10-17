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
    @IBOutlet var swich: UISwitch!
    
    @IBOutlet var addlabel: UILabel!
    @IBOutlet var schedulelabel: UILabel!
    @IBOutlet var daylabel: UILabel!
    @IBOutlet var sharelabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addlabel.backgroundColor = ColorManager.orange
        addlabel.textColor = UIColor.white
        schedulelabel.backgroundColor = ColorManager.orange
        schedulelabel.textColor = UIColor.white
        daylabel.backgroundColor = ColorManager.orange
        daylabel.textColor = UIColor.white
        sharelabel.backgroundColor = ColorManager.orange
        sharelabel.textColor = UIColor.white
        text.delegate = self
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    
    @IBAction func ok(sender: UIButton) {
        if text.text?.isEmpty == true{
            
        }else{
            
            let schedule = Schedule.create(title: text.text!, user: NCMBUser.current(), isPublic: swich.isOn, date: date.date as NSDate, done: false)
            Schedule.saveWithEvent(schedule: schedule, callBack: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func cancel () {
        self.dismiss(animated: true, completion: nil)
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