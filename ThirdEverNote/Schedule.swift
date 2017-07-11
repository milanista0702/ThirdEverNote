//
//  Schedule.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/01/10.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import Foundation
import NCMB

@objc(Schedule)
class Schedule: NCMBObject, NCMBSubclassing{
    var title: String! {
        get{
            return object(forKey: "title") as!
            String
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
    
    var isPublic: Bool {
        get {
            return object(forKey: "isPublic") as! Bool
        }
        set {
            setObject(newValue, forKey: "isPublic")
        }
    }
    
    var date: NSDate {
                get {
                    return object(forKey: "date") as! NSDate
                }
                set {
                    setObject(newValue, forKey: "date")
        }
    }
    
    var done: Bool {
        get {
            return object(forKey: "done") as! Bool
        }
        set {
            setObject(newValue, forKey: "done")
        }
    }
    
    override init!(className: String!) {
        super.init(className: className)
    }
    
    static func create(title: String, user: NCMBUser, isPublic: Bool, date: NSDate, done: Bool) -> Schedule{
        let schedule = Schedule(className: "Schedule")
        schedule?.title = title
        schedule?.user = user
        schedule?.isPublic = isPublic
        schedule?.date = date
        schedule?.done = done
        return schedule!
    }
    
    static func update(object: Schedule, title: String, user: NCMBUser, isPublic: Bool, date: NSDate, done: Bool) -> Schedule {
        if object.user == user {
            object.title = title
            object.user = user
            object.isPublic = isPublic
            object.date = date
        }
        return object
    }
    
    static func loadall(callback: @escaping ([Schedule]) -> Void) {
        let query = NCMBQuery(className: "Schedule")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.includeKey = "user"
        query?.order(byAscending: "date")
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if (objects?.count)! > 0 {
                    let obj = objects as! [Schedule]
                    callback(obj)
                }
            }
            
        }
    }
    
    static func saveWithEvent(schedule: Schedule, callBack: @escaping () -> Void) {
        schedule.saveEventually{ (error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return "Schedule"
    }
    
}
