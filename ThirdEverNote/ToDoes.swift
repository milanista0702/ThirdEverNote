//
//  ToDoes.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/06/21.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class ToDoes: NCMBObject, NCMBSubclassing {
    @NSManaged var todo: String! //内容
    @NSManaged var who: NCMBUser! //誰のか
    @NSManaged var isPublic: NSNumber!  //共有するかどうか
    @NSManaged var date: NSDate!        //期限
    @NSManaged var done: NSNumber!      //もうやったかどうか
    
    
    
    init(todo: String, who: NCMBUser, isPublic: NSNumber, date: NSDate) {
        super.init()
        self.todo = todo
        self.who = who
        self.isPublic = isPublic
        self.date = date
        self.done = 0
    }
    
    override init() {
        super.init()
    }
    
    static func ncmbClassName() -> String! {
        return "ToDoes"
    }
    
    static func create(titleOfToDoes todo: String, who: NCMBUser, isPublic: NSNumber, date: NSDate) {
        let todo = ToDoes(todo: todo, who: who, isPublic: isPublic, date: date)
        todo.saveEventually { (error) in
            if error != nil {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    static func loadAll() -> [ToDoes] {
        var todoes: [ToDoes] = []
        let query = NCMBQuery(className: self.ncmbClassName())
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                for todo in objects {
                    todoes.append(todo as! ToDoes)
                }
            }else {
                print("\(error.localizedDescription)")
            }
        }
        return todoes
    }
}

