//
//  RecipesViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase

class RecipesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK:Outlets
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBAction func favoriteBtnAction(_ sender: UIButton) {
        
    }
    
    //MARK:Properties
    var allRecipes:[Recipe]?
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellVisuality()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let instructionsVC = segue.destination as? InstructionsController{
            guard let recipe = sender as? Recipe else {return}
            instructionsVC.recipe = recipe
        }
    }
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allRecipes!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCellID", for: indexPath) as! RecipeViewCell
        let recipe = allRecipes![indexPath.row]
        recipeCell.populate(recipe: recipe)
        recipeCell.vc = self
        recipeCell.layer.borderWidth = 2
        recipeCell.layer.borderColor = #colorLiteral(red: 0.9611939788, green: 0.507047832, blue: 0.497117877, alpha: 1)
        
        return recipeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "recipesToInstructions", sender: allRecipes![indexPath.row])
    }
    
    func cellVisuality(){
        let cellSize = CGSize(width:recipeCollectionView.bounds.width * 0.9  , height:recipeCollectionView.bounds.height * 0.25)
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        
        layout.minimumLineSpacing = 25
        recipeCollectionView.setCollectionViewLayout(layout, animated: true)
        
        recipeCollectionView.reloadData()
    }
}
