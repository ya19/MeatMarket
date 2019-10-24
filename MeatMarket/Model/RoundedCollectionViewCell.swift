//
//  RoundedCollectionViewCell.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.

/**
    Rounded the corners of  CollectionViewCell
 */
import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 13
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 13
    }
    
}
