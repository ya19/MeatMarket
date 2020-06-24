//
//  ProtocolProfileFavorite.swift
//  MeatMarket
//
//  Created by YardenSwisa on 06/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import Foundation


protocol RemoveFavoriteProtocol {
    func refresh(recipeId:String)
}

protocol RemoveMyRecipesProtocol{
    func remove(recipeId:String)
}

protocol RemoveRecipe {
    func removeFavoritesRecipe(recipeId: String)
    func removeMyRecipes(recipeId: String)
}
