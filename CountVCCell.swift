//
//  ViewControllerTableViewCell.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-02-21.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

class CountVCCell: UITableViewCell {

    @IBOutlet weak var skillOutlet: UILabel!
    @IBOutlet weak var skillCounter: UILabel!
    @IBOutlet weak var SelectOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
