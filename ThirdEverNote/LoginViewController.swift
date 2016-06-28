//
//  LoginViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/06/21.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        usernameTextField.delegate = TextFieldDelegate()
        passwordTextField.delegate = TextFieldDelegate()
        
        passwordTextField.secureTextEntry = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction  func didSelectLogin() {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return}
        
        self.login(username, password: password)
    }
    
    func login (username: String, password:  String){
        NCMBUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if error != nil {
                print(error.localizedDescription)
            }else{
                if user.isAuthenticated() {
                    self.transition()
                }else{
                    self.presentAuthAlert()
                }
            }
        }
    }
    
    func presentAuthAlert() {
        let alert = UIAlertController(title: "Failure of user authentication", message: "Please do the authentication of mailaddress", preferredStyle: .Alert)
        let btn = UIAlertAction(title: <#T##String?#>, style: <#T##UIAlertActionStyle#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
        
    }
    
    func transition() {
        
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
