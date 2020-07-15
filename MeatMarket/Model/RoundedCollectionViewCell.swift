//
//  RoundedCollectionViewCell.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.

/**
    Rounded the corners of  CollectionViewCell
 */
import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 13
    }
    
}
