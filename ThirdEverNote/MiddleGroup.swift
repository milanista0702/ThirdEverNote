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
    
//    static func userGetName(objetct: MiddleGroup) -> Void {
//
//        let query = NCMBQuery(className: "user")
//        //query?.whereKey("objectsId", equalTo: objets.user.objectId)
//        query?.whereKey("objectId", equalTo: "NF5Zb9HXGKp9Lpwf")
////        query?.includeKey = "objectId"
//        query?.findObjectsInBackground({ (objetcs, error) in
//            let array = objetcs as? NCMBUser
//            print(array)
//            print("#########")
//            let user = objetcs as! NCMBObject
//            print(user.value(forKey: "userName"))
//
//            if error != nil {
//                print(error?.localizedDescription as Any)
//            }else{
//
////                if(objetcs?.count)! > 0 {
////
////                }
//                print("getuser")
//            }
//        })
//    }

    static func userGetName(object: MiddleGroup, callback: @escaping([String]) -> Void) {
        let query = NCMBUser.query()
        
        query?.whereKey("objectId", equalTo: object.user.objectId)
        query?.findObjectsInBackground({(objects, error) in
            let array = objects as? [NCMBUser]
            
            if error != nil {
                print(error?.localizedDescription as Any)
            }else{
                print(array?[0].value(forKey: "userName"))
                var returnName = [String]()
                returnName.append(array?[0].value(forKey: "userName") as! String)
                callback(returnName)
            }
        })
    }
    
    static func saveWithEvent(group: MiddleGroup,
                              callBack: @escaping () -> Void) {
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
