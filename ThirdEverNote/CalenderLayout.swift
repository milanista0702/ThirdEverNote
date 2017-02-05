//
//  CalenderLayout.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/02/05.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit

class CalenderLayout: UIViewController {
    
    var intervalX: Int!
    var intervalY: Int!
    var x: Int!
    var y: Int!
    var size: Int!
    var fontSize: Int!
    
    init(itervalX: Int, intervalY: Int, x: Int, y:Int, size:Int, fontSize: Int) {
        self.intervalX = intervalX
        self.intervalY = intervalY
        self.x = x
        self.y = y
        self.size = size
        self.fontSize = fontSize
    }
}
