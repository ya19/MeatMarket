//
//  MyRecipesViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 28/05/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit

class MyRecipesViewCell: UICollectionViewCell {
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var levelTextField: UILabel!
    @IBOutlet weak var timeTextField: UILabel!
    
    //MARK: Actions
    @IBAction func deleteTapped(_ sender: UIButton) {
        HelperFuncs.showToast(message: "Recipe Deleted", view: self)
    }
}
