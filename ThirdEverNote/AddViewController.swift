
//
//  AddViewController.swift
//
//
//  Created by makka misako on 2016/08/09.
//
//

import UIKit
import NCMB

class AddViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var text: UITextField!
    @IBOutlet var date: UIDatePicker!
    @IBOutlet var swich: UISwitch!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
            
            let todo = ToDoes.create(todo: text.text!, user: NCMBUser.current(), isPublic: swich.isOn, date: date.date as NSDate, done: 0)
            ToDoes.saveWithEvent(todo: todo, callBack: {
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
