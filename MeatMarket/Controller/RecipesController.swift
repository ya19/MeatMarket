//
//  RecipesViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase


class RecipesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RatingProtocol {
    //MARK:Outlets
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    //MARK:Properties
    var allRecipes:[Recipe]?
    var allMeatCuts:[MeatCut]?
    var ratingPassed = 0.0
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        allRecipes!.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellVisuality()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let instructionsVC = segue.destination as? InstructionsController{
            instructionsVC.ratingDelegate = self
            guard let recipe = sender as? Recipe else {return}
            instructionsVC.recipe = recipe
            print("\(recipe.name)<--- recipe.name RecipeVC")
            //test
            guard let meatcut = sender as? MeatCut else {return}
            instructionsVC.meatCut = meatcut
            print("\(meatcut.name)<--- meatCut.name RecipeVC")
            instructionsVC.ratingDelegate = self
        }
    }
    
    //MARK: Protocol Delegate
    func ratingAverage(rating: Double) {
        ratingPassed = rating
        
        print(ratingPassed,"rating test delegate")
    }
    
    
    func updateRates(recipeId:String) -> Double{
        if let navigationVC = self.navigationController as? NavigationController {
            for i in 0..<navigationVC.allMeatCuts!.count{
                for x in 0..<navigationVC.allMeatCuts![i].recipes!.count{
                    if recipeId == navigationVC.allMeatCuts![i].recipes![x].id{
                        return navigationVC.allMeatCuts![i].recipes![x].rating
                    }
                }
            }
        }
        return 0.0
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
//        recipeCell.layer.borderWidth = 1
//        recipeCell.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.6, blue: 0.3254901961, alpha: 1)
        recipeCell.rating.rating = updateRates(recipeId: recipe.id)
        
        return recipeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "recipesToInstructions", sender: allRecipes![indexPath.row])
    }
    
    func cellVisuality(){
        let cellSize = CGSize(width:recipeCollectionView.bounds.width * 0.9, height:recipeCollectionView.bounds.height * 0.40
        )
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        
        layout.minimumLineSpacing = 25
        recipeCollectionView.setCollectionViewLayout(layout, animated: true)
        
        recipeCollectionView.reloadData()
    }
    
}




