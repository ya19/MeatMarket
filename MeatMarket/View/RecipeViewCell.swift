//
//  RecipeViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 13/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase
class RecipeViewCell: RoundedCollectionViewCell , RecipeCellFavoriteStatusDelegate{
    
    //MARK:Properties
    var recipe:Recipe?
    var vc:UIViewController?
    var isFavorite:Bool?
    var once:Bool?
    //MARK:Outlets
    @IBOutlet weak var recipeLevelCell: UILabel!
    @IBOutlet weak var recipeTimeCell: UILabel!
    @IBOutlet weak var recipeNameCell: UILabel!
    @IBOutlet weak var recipeImageCell: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    //MARK: Actions
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        if once!{
            once = false
            if !isFavorite!{
                CurrentUser.shared.addToFavorite(recipe: recipe!, vc: vc!,delegate: self)
                changeStar(full: true)
            }else{
                CurrentUser.shared.removeFromFavorite(recipe: recipe!, vc: vc!,delegate: self)
                changeStar(full: false)
            }
            isFavorite = !isFavorite!
        }
    }
    func populate(recipe:Recipe){
        self.recipe = recipe
        self.once = true
        isFavorite = false
        recipeLevelCell.text = recipe.level.description
        recipeTimeCell.text = recipe.time
        recipeNameCell.text = recipe.name
        recipeImageCell.layer.cornerRadius = 10
        recipeImageCell.sd_setImage(with: recipe.image!)
        for favorite in CurrentUser.shared.user!.recipes{
            if favorite.id == recipe.id{
                isFavorite = true
            }
        }
        changeStar(full: isFavorite!)
    }
    func changeStar(full:Bool){
        if full{
            favoriteBtn.setImage(UIImage(named:"star_filled"), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: "star_blunk"), for: .normal)
        }
    }
    func changeStatus() {
        self.once = true
    }
}
protocol RecipeCellFavoriteStatusDelegate {
    func changeStatus()
}
