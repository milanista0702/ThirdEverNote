//
//  CalendarLayout.swift
//  ThirdEverNote
//
//  Created by ShinokiRyosei on 2017/01/31.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit

class CalendarLabelLayout {
    
    var intervalX: Int!
    var x: Int!
    var y: Int!
    var width: Int!
    var height: Int!
    var fontSize: Int!
    
    init(intervalX: Int, x: Int, y: Int, width: Int, height: Int, fontSize: Int) {
        self.intervalX = intervalX
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
}
