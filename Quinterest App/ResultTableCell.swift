//
//  ResultTableCellTableViewCell.swift
//  Quinterest App
//
//  Created by Rohit Lalchanadani on 6/13/15.
//  Copyright (c) 2015 Laucity. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
