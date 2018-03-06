//
//  TodoTableCell.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/09/20.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import UIKit

class TodoTableCell: UITableViewCell {
    
    @IBOutlet var todolabel : UILabel!
    @IBOutlet var datelabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var colorlabel : UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
