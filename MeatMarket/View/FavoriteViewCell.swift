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

    //MARK: Properties
    var recipe:Recipe?
    var vc:UIViewController?
    var delegate:RemoveFavoriteProtocol?
    
    //MARK: Actions
    @IBAction func deletTapped(_ sender: UIButton) {
        CurrentUser.shared.removeFromFavorite(recipe: recipe!, vc: vc!, delegate: delegate!)
    }
    
}
