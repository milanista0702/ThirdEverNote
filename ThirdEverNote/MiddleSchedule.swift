//
//  MiddleSchedule.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/09/12.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import Foundation
import NCMB

@objc(MiddleSchedule)
class MiddleSchedule: NCMBObject, NCMBSubclassing {
    var title: String! {
        get{
            return object(forKey: "title") as! String
        }
        set {
            setObject(newValue, forKey: "title")
        }
    }
    
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
    
    static func create(title: String, user: NCMBUser) -> Schedule{
        let MiddleSchedule = Schedule(className: "MiddleSchedule")
        MiddleSchedule?.title = title
        MiddleSchedule?.user = user
        return MiddleSchedule!
    }
    
    static func update(object: MiddleSchedule, title: String, user: NCMBUser) -> MiddleSchedule {
        if object.user == user {
            object.title = title
            object.user = user
        }
        return object
    }
    
    static func loadall(callback: @escaping ([MiddleSchedule]) -> Void) {
        let query = NCMBQuery(className: "MiddleSchedule")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.includeKey = "user"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if (objects?.count)! > 0 {
                    let obj = objects as! [MiddleSchedule]
                    callback(obj)
                }
            }
            
        }
    }
    
    static func saveWithEvent(MiddleSchedule: MiddleSchedule, callBack: @escaping () -> Void) {
        MiddleSchedule.saveEventually{ (error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return "MiddleSchedule"
    }
    
    
}
