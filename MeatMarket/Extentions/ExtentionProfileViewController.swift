//
//  ExtentionProfileViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 06/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import Foundation

extension ProfileController:RemoveFavoriteProtocol{
    func refresh(recipeId:String){
        for i in 0..<CurrentUser.shared.user!.recipes.count {
            if recipeId == CurrentUser.shared.user!.recipes[i].id{
                    self.favoriteCollectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
            }
        }
        self.favoriteCollectionView.reloadData()
        
    }
}
