//
//  User.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/12/12.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import Foundation
import NCMB

@objc(User)
class User: NCMBObject, NCMBSubclassing{
    var user: NCMBUser {
        get {
            return object(forKey: "user") as! NCMBUser
        }
        set {
            setObject(newValue, forKey:"user")
        }
    }
    
    override init!(className: String!) {
        super.init(className: className)
    }
    
    static func create(user: NCMBUser) -> User{
        let users = User(className: "User")
        users?.user = user
        return users!
    }
    
    static func update(object: User, user: NCMBUser) -> User {
        if object.user == user {
            object.user = user
        }
        return object
    }
    
    static func loadall(callback: @escaping ([User]) -> Void) {
        let query = NCMBQuery(className: "User")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.includeKey = "user"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if (objects?.count)! > 0 {
                    let obj = objects as! [User]
                    callback(obj)
                }
            }
            
        }
    }
    
    static func saveWithEvent(schedule: User, callBack: @escaping () -> Void) {
        schedule.saveEventually{ (error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return "User"
    }
    
}

