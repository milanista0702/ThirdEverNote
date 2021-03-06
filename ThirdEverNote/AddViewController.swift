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
    
    var screenback: Bool!
    var screenbacks: Bool!
    
    var fromcreate: Bool!
    
    var membersArray = [NCMBUser]() //createの方から
    var groupcreates: Group! //createの方から
    var exgroupArray = [NCMBUser]() //Searchの方から
    var searchgroupname: Group!
    var todo: ToDoes!
    
    let userDefaults = UserDefaults.standard
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //判定
        screenback = true
        userDefaults.set(screenback, forKey:"addtrue")
        
        screenbacks = true
        userDefaults.set(screenbacks, forKey: "addsearch")
        
        
        text.delegate = self
        
        let graduationLayer = CAGradientLayer()
        let graduationLayer2 = CAGradientLayer()
        let graduationLayer3 = CAGradientLayer()
        let graduationLayer4 = CAGradientLayer()
        
        graduationLayer.frame = self.addlabel.bounds
        graduationLayer2.frame = self.todolabel.bounds
        graduationLayer3.frame = self.limitlabel.bounds
        graduationLayer4.frame = self.sharelabel.bounds
        
        let color1 = UIColor(red: 0.05, green: 0.6, blue: 0.5, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0.6, green: 1.0, blue: 0.5, alpha: 1.0).cgColor
        
        graduationLayer.colors = [color1, color2]
        graduationLayer2.colors = [color1, color2]
        graduationLayer3.colors = [color1, color2]
        graduationLayer4.colors = [color1, color2]
        
        graduationLayer.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    
        graduationLayer2.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer2.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        graduationLayer3.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer3.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        graduationLayer4.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer4.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        addlabel.layer.insertSublayer(graduationLayer, at: 0)
        addlabel.text = "ADD TODO"
        addlabel.textColor = UIColor.white
        
        todolabel.layer.insertSublayer(graduationLayer2, at: 0)
        todolabel.textColor = UIColor.white
        
        limitlabel.layer.insertSublayer(graduationLayer3, at: 0)
        limitlabel.textColor = UIColor.white
        
        sharelabel.layer.insertSublayer(graduationLayer4, at: 0)
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
            let alert = UIAlertController(title: "Inadequate", message: "write TODO", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            if shareswitch.isOn == true {
                
                //from create
                if fromcreate == true {
                    for element in self.membersArray {
                        todo = ToDoes.create(todo: text.text!, user: element, isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                        ToDoes.saveWithEvent(todo: todo, callBack: saveGTS)
                    }
                    
                    //from existing
                }else{
                    for element in self.membersArray {
                        let todo = ToDoes.create(todo: text.text!, user: element, isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                        ToDoes.saveWithEvent(todo: todo, callBack: searchsaveGTS)
                    }
                }
                
                fromcreate = true
                self.dismiss(animated: true, completion: nil)
            }else{
                let todo = ToDoes.create(todo: text.text!, user: NCMBUser.current(), isPublic: shareswitch.isOn, date: date.date as NSDate, done: false)
                ToDoes.saveWithEvent(todo: todo, callBack: nillsaveGTS)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func saveGTS(todo: ToDoes) {
        let GTS = MiddleGTS.create(Todo: todo, Schedule: nil, group: groupcreates!)
        MiddleGTS.saveWithEvent(group: GTS, callBack: {})
    }
    
    func searchsaveGTS(todo: ToDoes) {
        let GTS = MiddleGTS.create(Todo: todo, Schedule: nil, group: searchgroupname!)
        MiddleGTS.saveWithEvent(group: GTS, callBack: {})
    }
    
    func nillsaveGTS(todo: ToDoes) {
        let GTS = MiddleGTS.create(Todo: todo, Schedule: nil, group: nil!)
        MiddleGTS.saveWithEvent(group: GTS, callBack: {})
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
