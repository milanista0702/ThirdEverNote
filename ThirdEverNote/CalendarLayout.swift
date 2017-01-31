//
//  CalendarLayout.swift
//  ThirdEverNote
//
//  Created by ShinokiRyosei on 2017/01/31.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit

class CalendarLayout {
    
    var intervalX: Int!
    var intervalY: Int!
    var x: Int!
    var y: Int!
    var size: Int!
    var fontSize: Int!
    
    init(intervalX: Int, intervalY: Int, x: Int, y: Int, size: Int, fontSize: Int) {
        
        self.intervalX = intervalX
        self.intervalY = intervalY
        self.x = x
        self.size = size
        self.fontSize = fontSize
    }
}
