//
//  MiddleGTS.swift
//  ThirdEverNote
//
//  Created by makka misako on 2018/03/27.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import UIKit
import NCMB

@objc(MiddleGTS)
class MiddleGTS: NCMBObject, NCMBSubclassing {
    var group: Group? {
        get {
            return object(forKey: "group") as? Group
        }
        set {
            setObject(newValue, forKey: "group")
        }
    }
    
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
    
    
    override init!(className: String!) {
        super.init(className: className)
    }
    
    static func create(Todo: ToDoes?, Schedule: Schedule?, group: Group) -> MiddleGTS{
        let middleGTS = MiddleGTS(className: "MiddleGTS")
        middleGTS?.Todo = Todo
        middleGTS?.Schedule = Schedule
        middleGTS?.group = group
        return middleGTS!
    }
    
    static func update(object: MiddleGTS, Todo: ToDoes?, Schedule: Schedule?, group: Group) -> MiddleGTS {
        if object.group == group {
            object.Todo = Todo
            object.Schedule = Schedule
        }
        return object
    }
    
    static func loadall(callback: @escaping([MiddleGTS]) -> Void) {
        let query = NCMBQuery(className: "MiddleGTS")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.includeKey = "user"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if(objects?.count)! > 0 {
                    let obj = objects as! [MiddleGTS]
                    callback(obj)
                }
            }
        }
    }
    
    static func saveWithEvent(group: MiddleGTS,callBack: @escaping () -> Void) {
        group.saveEventually{(error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return"MiddleGTS"
    }
    
}
