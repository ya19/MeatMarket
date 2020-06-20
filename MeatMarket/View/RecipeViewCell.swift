//
//  RecipeViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 13/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class RecipeViewCell: RoundedCollectionViewCell , RecipeCellFavoriteStatusDelegate{
    
    //MARK:Outlets
    @IBOutlet weak var recipeLevelCell: UILabel!
    @IBOutlet weak var recipeTimeCell: UILabel!
    @IBOutlet weak var recipeNameCell: UILabel!
    @IBOutlet weak var recipeImageCell: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var rating: CosmosView! //UpdateOnTouch = false(storyboard)(just for present the rating)
    
    //MARK:Properties
    var recipe:Recipe?
    var vc:UIViewController?
    var isFavorite:Bool?
    var once:Bool?
    
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
    
    //MARK: Funcs
    func populate(recipe:Recipe){
        self.recipe = recipe
        self.once = true
        isFavorite = false
        recipeLevelCell.text = recipe.level.description
        recipeTimeCell.text = recipe.time
        recipeNameCell.text = recipe.name
        recipeImageCell.layer.cornerRadius = 10
        self.rating.rating = recipe.rating
        recipeImageCell.sd_setImage(with: recipe.image ?? nil)
        
        for favorite in CurrentUser.shared.user!.favoriteRecipes{
            if favorite.id == recipe.id{
                isFavorite = true
            }
        }
        changeStar(full: isFavorite!)
    }
    
    func changeStar(full:Bool){
        if full{
            favoriteBtn.setImage(UIImage(named:"icons8-add_to_favorites_filled"), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: "icons8-add_to_favorites"), for: .normal)
        }
    }
    
    func changeStatus() {
        self.once = true
    }
    
}

