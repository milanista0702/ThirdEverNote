//
//  CalendarLabelLayout.swift
//  ThirdEverNote
//
//  Created by makka misako on 2017/02/05.
//  Copyright © 2017年 makka misako. All rights reserved.
//

import UIKit

class CalendarLabelLayout: UIViewController {
    
    var intervalX: Int!
    var x: Int!
    var y: Int!
    var width: Int!
    var height: Int!
    var fontSize: Int!
    
    init(intervalX: Int, x: Int, y: Int, width: Int, height: Int, fontSize: Int) {
        self.intervalX = intervalX
        self.x = x
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
}
