//
//  ViewController2TableViewCell.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-02.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

class CheckVCCell: UITableViewCell {
    
    var spaceOfItems = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var labels : [UILabel] = { // DayWeek, Total, 1stProp, 2ndProp, 3rdProp, 4thProp
        let label = [UILabel(),UILabel(),UILabel(),UILabel(),UILabel(),UILabel()]
        for lbl in label {
            lbl.translatesAutoresizingMaskIntoConstraints = false
        }
        return label
    }()
        
    func setupViews() {
        for label in labels {
            addSubview(label)
        }
    }

}
