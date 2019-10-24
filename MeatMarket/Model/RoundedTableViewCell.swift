//
//  RoundedTableViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 22/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

/**
    Rounded the corners of  TableViewCell
 */
import UIKit

class RoundedTableViewCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 13
    }
    
}
