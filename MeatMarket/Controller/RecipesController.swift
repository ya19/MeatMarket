//
//  RecipesViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

class RecipesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK:Outlets
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    

    //MARK:Properties
    var allRecipes:[Recipe]?

    //MARK: LiveCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellVisuality()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let instructionsVC = segue.destination as? InstructionsController{
            guard let recipe = sender as? Recipe else {return}
            instructionsVC.recipe = recipe
        }
    }
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allRecipes!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCellID", for: indexPath) as! RecipeViewCell
        let recipe = allRecipes![indexPath.row]
        recipeCell.recipeNameCell.text = recipe.name
        recipeCell.recipeLevelCell.text = recipe.level.description
        recipeCell.recipeTimeCell.text = recipe.time
        recipeCell.recipeImageCell.roundCorners(.allCorners, radius: 15)
        recipeCell.recipeImageCell.sd_setImage(with: recipe.image)
        
        return recipeCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "recipesToInstructions", sender: allRecipes![indexPath.row])
    }
    
    func cellVisuality(){
        let cellSize = CGSize(width:recipeCollectionView.bounds.width * 0.9 , height:150)
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 25
        recipeCollectionView.setCollectionViewLayout(layout, animated: true)

        recipeCollectionView.reloadData()
    }
}
