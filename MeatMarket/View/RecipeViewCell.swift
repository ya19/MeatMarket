//
//  RecipeViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 13/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase
class RecipeViewCell: RoundedCollectionViewCell {
    //MARK:Properties
    var recipe:Recipe?
    //MARK:Outlets
    @IBOutlet weak var recipeLevelCell: UILabel!
    @IBOutlet weak var recipeTimeCell: UILabel!
    @IBOutlet weak var recipeNameCell: UILabel!
    @IBOutlet weak var recipeImageCell: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    //MARK: Actions
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        Database.database().reference().child("Favorites").child(User.shared.id!).child(recipe!.id).setValue(ServerValue.timestamp())
    }
    
}
