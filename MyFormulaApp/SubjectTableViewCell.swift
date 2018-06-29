//
//  SubjectTableViewCell.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import MarqueeLabel

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet var lblTopicName: UILabel!
    @IBOutlet var lblTopicInitials: UILabel!
    @IBOutlet var lblMainTopicSubject: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
