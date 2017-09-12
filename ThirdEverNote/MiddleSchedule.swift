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
class MiddleSchedule: NSObject, NCMBSubclassing {
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
    
}
