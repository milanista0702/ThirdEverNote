//
//  MiddleGroup.swift
//  ThirdEverNote
//
//  Created by makka misako on 2018/01/16.
//  Copyright © 2018年 makka misako. All rights reserved.
//

import Foundation
import NCMB

@objc(MiddleGroup)
class MiddleGroup: NCMBObject, NCMBSubclassing {
    var group: Group {
        get {
            return object(forKey: "group") as! Group
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
    
    static func create(group: Group, user: NCMBUser) -> MiddleGroup{
        let middlegroup = MiddleGroup(className: "MiddleGroup")
        middlegroup?.group = group
        middlegroup?.user = user
        return middlegroup!
    }
    
    static func update(object: MiddleGroup, group: Group, user: NCMBUser) -> MiddleGroup {
        if object.user == user {
            object.group = group
        }
        return object
    }
    
    static func loadall(callback: @escaping([MiddleGroup]) -> Void) {
        let query = NCMBQuery(className: "MiddleGroup")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.includeKey = "user"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if(objects?.count)! > 0 {
                    let obj = objects as! [MiddleGroup]
                    callback(obj)
                }
            }
        }
    }
    
    static func loadall2(mygroup: Group, callback: @escaping([MiddleGroup]) -> Void) {
        let query = NCMBQuery(className: "MiddleGroup")
        query?.whereKey("group", equalTo: mygroup )
        query?.includeKey = "group"
        query?.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                if(objects?.count)! > 0 {
                    let obj = objects as! [MiddleGroup]
                    callback(obj)
                }
            }
            
        }
    }
    
    static func saveWithEvent(group: MiddleGroup,
                              callBack: @escaping () -> Void) {
//        print("MiddleGroupsave...\(group)")
        group.saveEventually{(error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                callBack()
            }
        }
    }
    
    static func ncmbClassName() -> String! {
        return"MiddleGroup"
    }
}
