//
//  ExtentionUIImageViewAndUIImage.swift
//  MeatMarket
//
//  Created by YardenSwisa on 06/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit

extension UIImageView {
    
    //MARK: Round the UIImageView
    func setRounded(borderWidth: CGFloat = 0.0, borderColor: UIColor = UIColor.clear) {
        print(" Height: \(frame.height), Witdh: \(frame.width)")
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
//        clipsToBounds = false
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

