//
//  Group.swift
//  ThirdEverNote
//
//  Created by makka misako on 2018/01/16.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import Foundation
import NCMB

@objc(Group)
class Group: NCMBObject, NCMBSubclassing {
    var name: String? {
        get{
            return object(forKey: "name") as? String
        }
        set{
            setObject(newValue, forKey: "name")
        }
    }
    
    static func getName(id: String, callback: @escaping([Group]) -> Void) {
        let query = NCMBQuery(className: "Group")
        query?.whereKey("objectId", equalTo: id)
        query?.includeKey = "objectId"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if(objects?.count)! > 0 {
                    let obj = objects as! [Group]
                    callback(obj)
                }
                print("getname")
            }
        }
    }
    
    static func search(name: String, callback: @escaping([Group]) -> Void) {
        let query = NCMBQuery(className: "Group")
        query?.whereKey("GroupName", equalTo: name)
        query?.includeKey = "GroupName"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if (objects?.count)! > 0 {
                    let obj = objects as! [Group]
                    callback(obj)
                }
                print("search")
            }
        }
    }
    
    override init!(className: String!){
        super.init(className: className)
    }
    
    static func create(name: String) -> Group{
        let group = Group(className: "Group")
        group?.name = name
        return group!
    }
    
    static func update(object: Group, name: String) -> Group {
        object.name = name
        return object
    }
    static func saveWithEvent(name: Group, callBack: @escaping () -> Void) {
        print("Groupsave.\(name)")
        name.saveEventually { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return "Group"
    }
}

extension NCMBUser {
    static func getName(id: String, callback: @escaping([NCMBUser]) -> Void) {
        let query = NCMBQuery(className: "NCMBUser")
        query?.whereKey("objectId", equalTo: id)
        query?.includeKey = "objectId"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if(objects?.count)! > 0 {
                    let obj = objects as! [NCMBUser]
                    callback(obj)
                }
                print("getname \(String(describing: objects?.count))")
            }
        }
    }
}
