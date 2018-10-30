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
    @IBOutlet var shareswitch: UISwitch!
    @IBOutlet var addlabel: UILabel!
    @IBOutlet var todolabel: UILabel!
    @IBOutlet var limitlabel: UILabel!
    @IBOutlet var sharelabel: UILabel!
    
    var exgroupArray = [Group]()
    var groupcreates: Group!
    var completion: ((Group) -> Void)!
    
    var membersArray = [NCMBUser]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        
        addlabel.backgroundColor = ColorManager.green
        addlabel.textColor = UIColor.white
        todolabel.backgroundColor = ColorManager.green
        todolabel.textColor = UIColor.white
        limitlabel.backgroundColor = ColorManager.green
        limitlabel.textColor = UIColor.white
        sharelabel.backgroundColor = ColorManager.green
        sharelabel.textColor = UIColor.white
        
        shareswitch.isOn = false
        shareswitch.addTarget(self, action: #selector(AddViewController.onClick(sender:)), for: .valueChanged)
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    @objc func onClick (sender: UISwitch) {
        if sender.isOn{
            self.showalert()
        }else{
        }
    }
    
    func showalert() {
        let alert = UIAlertController(title: "Group", message: "Create a NewGroup\nor\nExisting Group", preferredStyle: .alert)
        
        
        let action1 = UIAlertAction(title: "Create a New Group", style: .default) { _ in
            self.performSegue(withIdentifier: "todonewsegue", sender: self.text.text)
            
        }
        let action2 = UIAlertAction(title: "Existing Group", style: .default) { _ in
            self.performSegue(withIdentifier: "todosearch", sender: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ok(sender: UIButton) {
        if text.text?.isEmpty == true{
        }else{
            for element in self.membersArray{
                let todo = ToDoes.create(todo: text.text!, user: element,isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                ToDoes.saveWithEvent(todo: todo, callBack: {})
                
                let GTS = MiddleGTS.create(Todo: todo, Schedule: nil, group: groupcreates!)
                MiddleGTS.saveWithEvent(group: GTS, callBack:{})
                
                self.dismiss(animated: true, completion: nil)
                
                if todo.isPublic == true {
                }
            }
        }
    }
    
    
    @IBAction func cancel () {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "todonewsegue" {
            let GroupCreateViewControllerTwo = segue.destination as! GroupCreateViewController
            GroupCreateViewControllerTwo.todotext = sender as? String
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
