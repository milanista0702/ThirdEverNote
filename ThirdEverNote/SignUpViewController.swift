//
//  SignUpViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/06/21.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var createpasswordTextField: UITextField!
    @IBOutlet var confirmpasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        createpasswordTextField.delegate = self
        confirmpasswordTextField.delegate = self
        
        // 文字が黒丸になるように
        createpasswordTextField.secureTextEntry = true
        confirmpasswordTextField.secureTextEntry = true
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSeletSignup() {
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = createpasswordTextField.text else {return }
        guard let confirmpassword = confirmpasswordTextField.text else { return }
        
        if confirmpassword == password {
            self.signup(username, email: email, password: password)
        }else {
            self.presntPassConfirmAlert()
        }
        
      }
    
    
    func signup ( username: String, email: String, password: String) {
        let user = NCMBUser(className: "user")
        user.password = password
        user.mailAddress = email
        user.userName = username
        if user.isNew == false {
            user.signUpInBackgroundWithBlock { (error) in
                if error != nil {
                    print(error.localizedDescription)
                }else {
                    self.requestAuthentication(email: email)
                }
            }
            
        }else {
            print("usernameが被ってる")
            self.presentCheckUsernameAlert()
        }
    }
    
    func presntPassConfirmAlert () {
        let alert = UIAlertController(title: "password does not agree", message: "lease input password once more", preferredStyle: .Alert)
        let btn = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.confirmpasswordTextField.text = ""
            self.confirmpasswordTextField.text = ""
        }
        alert.addAction(btn)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func requestAuthentication (email address: String) {
        NCMBUser.requestAuthenticationMailInBackground(address, block: { (error) in
            if error != nil {
                print(error.localizedDescription)
            }else{
                self.transition()
            }
        })
    }
    
    
    func presentCheckUsernameAlert () {
        let alert = UIAlertController(title: "username errror", message: "The user name which is posted it is already registered. \n Please post username which is different ", preferredStyle: .Alert)
        let btn = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.usernameTextField.text = ""
        })
        alert.addAction(btn)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //segueの指定
    func transition() {
        self.performSegueWithIdentifier("toLoginView", sender: nil)
    }
    
    func toView ()  {
        self.performSegueWithIdentifier("toView", sender: nil)
    }
    
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "pasword does not agree", message:"", preferredStyle:  UIAlertControllerStyle.Alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
            print ("OK")
        })
        
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func login () {
        self.transition()
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
