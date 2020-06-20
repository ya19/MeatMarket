//
//  RecipeCollectionViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
class FavoriteViewCell: RoundedCollectionViewCell {

    //MARK: Outlets
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteRecipeName: UILabel!
    @IBOutlet weak var favoriteRecipeLevel: UILabel!
    @IBOutlet weak var favoriteRecipeTime: UILabel!
    @IBOutlet weak var favoriteMeatCutName: UILabel!
    
    //MARK: Properties
    var recipe:Recipe?
    var vc:UIViewController?
    var delegate:RemoveFavoriteProtocol?
    
    //MARK: Actions
    @IBAction func deletTapped(_ sender: UIButton) {
        CurrentUser.shared.removeFromFavorite(recipe: recipe!, vc: vc!, delegate: delegate!)
    }
    
    func populate(recipe:Recipe, vc: ProfileController){
        self.favoriteRecipeName.text = recipe.name
        self.favoriteRecipeLevel.text =  recipe.level.description
        self.favoriteRecipeTime.text = recipe.time
        self.favoriteMeatCutName.text = recipe.meatcutName
        self.favoriteImageView.sd_setImage(with: recipe.image)
        self.favoriteImageView.layer.cornerRadius = 10
        self.recipe = recipe
        self.vc = vc
        self.delegate = vc
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
}
