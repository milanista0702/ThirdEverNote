//
//  MiddleGTU.swift
//  ThirdEverNote
//
//  Created by makka misako on 2018/03/27.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import UIKit
import NCMB

@objc(MiddleGTU)
class MiddleGTU: NCMBObject, NCMBSubclassing {
    var Todo: ToDoes? {
        get {
            return object(forKey: "Todo") as? ToDoes
        }
        set {
            setObject(newValue, forKey: "Todo")
        }
    }
    
    var Schedule: Schedule? {
        get {
            return object(forKey: "Schedule") as? Schedule
        }
        set {
            setObject(newValue, forKey: "Schedule")
        }
    }
    
    var group: Group? {
        get {
            return object(forKey: "group") as? Group
        }
        set {
            setObject(newValue, forKey: "group")
        }
    }
    
    var user: NCMBUser {
        get {
            return object(forKey: "user") as! NCMBUser
        }
        set {
            setObject(newValue, forKey: "user")
        }
    }
    
    override init!(className: String!) {
        super.init(className: className)
    }
    
    static func create(Todo: ToDoes, Schedule: Schedule?, group: Group, user: NCMBUser) -> MiddleGTU{
        let middleGTU = MiddleGTU(className: "MiddleGTU")
        middleGTU?.Todo = Todo
        middleGTU?.Schedule = Schedule
        middleGTU?.group = group
        middleGTU?.user = user
        return middleGTU!
    }
    
    static func update(object: MiddleGTU, Todo: ToDoes, Schedule: Schedule?, group: Group, user: NCMBUser) -> MiddleGTU {
        if object.user == user {
            object.group = group
            object.Todo = Todo
            object.Schedule = Schedule
        }
        return object
    }
    
    static func loadall(callback: @escaping([MiddleGTU]) -> Void) {
        let query = NCMBQuery(className: "MiddleGTU")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.includeKey = "user"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if(objects?.count)! > 0 {
                    let obj = objects as! [MiddleGTU]
                    callback(obj)
                }
            }
        }
    }
    
    static func saveWithEvent(group: MiddleGTU,callBack: @escaping () -> Void) {
        group.saveEventually{(error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return"MiddleGTU"
    }
    
}
