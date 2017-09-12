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
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        confirmpasswordTextField.delegate = self
        createpasswordTextField.delegate = self
        
        // 文字が黒丸になるように
        
        createpasswordTextField.isSecureTextEntry = true
        confirmpasswordTextField.isSecureTextEntry = true
        
        signUpButton.setTitleColor(ColorManager.navy, for: .normal)
        signinButton.setTitleColor(ColorManager.navy, for: .normal)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didSeletSignup() {
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = createpasswordTextField.text else {return }
        guard let confirmpassword = confirmpasswordTextField.text else { return }
        
        if confirmpassword == password {
            self.signup(username: username, email: email, password: password)
        }else {
            self.presntPassConfirmAlert()
        }
        self.toView()
        
    }
    
    
    func signup ( username: String, email: String, password: String) {
        let user = NCMBUser(className: "user")
        user?.password = password
        user?.mailAddress = email
        user?.userName = username
        if user?.isNew == false {
            user?.signUpInBackground { (error) in
                if error != nil {
                    print(error?.localizedDescription)
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
        let alert = UIAlertController(title: "password does not agree", message: "lease input password once more", preferredStyle: .alert)
        let btn = UIAlertAction(title: "OK", style: .default) { (action) in
            self.confirmpasswordTextField.text = ""
            self.confirmpasswordTextField.text = ""
        }
        alert.addAction(btn)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func requestAuthentication (email address: String) {
        NCMBUser.requestAuthenticationMail(inBackground: address, block: { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                self.transition()
            }
        })
    }
    
    
    func presentCheckUsernameAlert () {
        let alert = UIAlertController(title: "username errror", message: "The user name which is posted it is already registered. \n Please post username which is different ", preferredStyle: .alert)
        let btn = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.usernameTextField.text = ""
        })
        alert.addAction(btn)
        self.present(alert, animated: true, completion: nil)
    }
    
    //segueの指定
    func transition() {
        self.performSegue(withIdentifier: "toLoginView", sender: nil)
    }
    
    func toView ()  {
        self.performSegue(withIdentifier: "toView", sender: nil)
    }
    
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "pasword does not agree", message:"", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) -> Void in
            print ("OK")
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func login () {
        self.transition()
    }
    
}
