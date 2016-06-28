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
        
        usernameTextField.delegate = TextFieldDelegate()
        emailTextField.delegate = TextFieldDelegate()
        createpasswordTextField.delegate = TextFieldDelegate()
        confirmpasswordTextField.delegate = TextFieldDelegate()
        
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
        
        if password == confirmpassword {
            self.alert ()
        }
        else{
            
            self.signup(username, email: password, password: email, confirmpassword: confirmpassword)
            
            self.transition()
        }
        
    }
    
    func signup ( username: String, email: String, password: String, confirmpassword: String) {
        let user = NCMBUser(className: "user")
        user.password = password
        user.mailAddress = email
        user.userName = username
        user.signUpInBackgroundWithBlock { (error) in
            if error != nil {
                print (error.localizedDescription)
            }else{
                NCMBUser.requestAuthenticationMailInBackground(email, block: {(error)in
                    if error != nil {
                        print (error.localizedDescription)
                    }else{
                        self.transition()
                    }
                    
                })
            }
            
        }
        
    }
    
    //segueの指定
    func transition() {
        self.performSegueWithIdentifier("toLoginView", sender: nil)
    }
    
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "pasword does not agree", message:"", preferredStyle:  UIAlertControllerStyle.Alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
            print ("OK")
        })
        
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
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
