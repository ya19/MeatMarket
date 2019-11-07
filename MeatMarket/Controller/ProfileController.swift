//
//  ProfileController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: Actions
    

    //MARK: LiveCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        
        userNameLabel.text = "\(CurrentUser.shared.user!.firstName!) \(CurrentUser.shared.user!.lastName!)"
        profileImageView.image = #imageLiteral(resourceName: "lake").circleMasked
//        profileImageView.setRounded()
//        profileImageView.layer.masksToBounds = false
//        profileImageView.clipsToBounds = true
//        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
//    override func viewWillLayoutSubviews() {
//      super.viewWillLayoutSubviews()
//        profileImageView.setRounded(borderWidth: 1, borderColor: .blue)
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let instructionsVC = segue.destination as? InstructionsController{
            guard let recipe = sender as? Recipe else {return}
            instructionsVC.recipe = recipe
        }
    }
    
    //MARK: CollecionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentUser.shared.user!.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteViewCell
        let recipe = CurrentUser.shared.user!.recipes[indexPath.row]
        
        cell.favoriteRecipeName.text = recipe.name
        cell.favoriteRecipeLevel.text =  recipe.level.description
        cell.favoriteRecipeTime.text = recipe.time
//        cell.favoriteImageView.layer.cornerRadius = 13
        
        cell.favoriteImageView.sd_setImage(with: recipe.image)
        cell.recipe = recipe
        cell.vc = self
        cell.delegate = self
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "profileToInstructions", sender: CurrentUser.shared.user!.recipes[indexPath.row])
    }
    
//        func cellVisuality(){
//        let cellSize = CGSize(width:favoriteCollectionView.bounds.width * 0.9, height:0)
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = cellSize
//        layout.minimumLineSpacing = 25
//        favoriteCollectionView.setCollectionViewLayout(layout, animated: true)
//
//        favoriteCollectionView.reloadData()
//    }
}

protocol RemoveFavoriteProtocol {
    func refresh(recipeId:String)
}

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
