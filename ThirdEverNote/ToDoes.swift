//
//  ToDoes.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/06/21.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import Foundation
import NCMB

@objc(ToDoes)
class ToDoes: NCMBObject, NCMBSubclassing{
    var todo: String! {
        get {
            return objectForKey("todo") as! String
        }
        set {
            setObject(newValue, forKey: "todo")
        }
    }
    
    var user: NCMBUser {
        get  {
            return objectForKey("user") as!  NCMBUser
        }
        set {
            setObject(newValue, forKey: "user")
        }
    }
    
    var isPublic: Bool {
        get {
            return objectForKey("isPublic") as! Bool
        }
        set {
            setObject(newValue, forKey: "isPublic")
        }
    }
    
    var date: NSDate {
        get {
            return objectForKey("date") as! NSDate
        }
        set {
            setObject(newValue, forKey: "date")
        }
    }
    
    var done: Int {
        get {
            return objectForKey("done") as! Int
        }
        set {
            setObject(newValue, forKey: "done")
        }
    }
    
    //呼び出すときのclassNameを設定
    override init!(className: String!) {
        super.init(className: className)
    }
    
    static func create(todo: String, user: NCMBUser, isPublic: Bool, date: NSDate, done: Int) -> ToDoes{
        let toDoes = ToDoes(className: "ToDoes")
        toDoes.todo = todo
        toDoes.user = user
        toDoes.isPublic = isPublic
        toDoes.date = date
        toDoes.done = done
        return toDoes
    }
    
    static func update(object: ToDoes, todo: String, user: NCMBUser, isPublic: Bool, date: NSDate, done: Int) -> ToDoes {
        if object.user == user {
            object.todo = todo
            object.user = user
            object.isPublic = isPublic
            object.date = date
        }
        return object
    }
    
    static func loadall(callback: ( [ToDoes]) -> Void) {
        let query = NCMBQuery(className: "ToDoes")
        query.whereKey("user", equalTo: NCMBUser.currentUser())
        query.includeKey = "user"
        query.orderByAscending("date")
        query.findObjectsInBackgroundWithBlock{ (objects, error) in
            if error != nil {
                print(error.localizedDescription)
            } else {
                if objects.count > 0 {
                    let obj = objects as! [ToDoes]
                    callback(obj)
                }
            }
            
        }
    }
    
    static func saveWithEvent(todo: ToDoes, callBack: () -> Void) {
        todo.saveEventually { (error) in
            if error != nil {
                print(error.localizedDescription)
            }else{
                callBack()
            }
        }
        
    }
    
    static func ncmbClassName() -> String! {
        return "ToDoes"
    }
    
}
