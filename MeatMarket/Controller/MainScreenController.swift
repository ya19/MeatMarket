//
//  MainScreenController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

//MARK: Protocols
//protocol CreateRecipeDelegate: class{
//    func getRecipeMeatCuts(meatCuts:[MeatCut])
//}

//MARK: Global Propertie 
var globalOnce = true

class MainScreenController: UIViewController{
    
    //MARK: Outlets
    @IBOutlet weak var meatCutCollectionView: UICollectionView!
    
    //MARK: Properties
    var allMeatCuts:[MeatCut]?
    var allRecipes:[Recipe]?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navigationVC = self.navigationController as? NavigationController{
            self.allMeatCuts = navigationVC.allMeatCuts
            self.liveRating(navigationVC:navigationVC)
        }
        
        self.allMeatCuts!.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        
        print(allMeatCuts!.count, "MainVC allMeatCuts.count")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipesController{
            guard let recipes = sender as? [Recipe] else {return}
            recipesVC.allRecipes = recipes
            guard let meatCuts = sender as? [MeatCut] else {return}
            recipesVC.allMeatCuts = meatCuts
        }
        // test delegate
        if let createRecipeVC = segue.destination as? CreateRecipeController{
            guard let allMeatCuts = sender as? [MeatCut] else {return}
            createRecipeVC.allMeatCuts = allMeatCuts
        }
    }
    
    //MARK: Actions
    @IBAction func brisketTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![0].recipes)
    }
    @IBAction func chuckTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![1].recipes)
    }
    @IBAction func filletTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![2].recipes)
    }
    @IBAction func flankTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![3].recipes)
    }
    @IBAction func plateTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![4].recipes)
    }
    @IBAction func porterhouseTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![5].recipes)
    }
    @IBAction func ribTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![6].recipes)
    }
    @IBAction func shankTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![7].recipes)
    }
    @IBAction func sirloinTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![8].recipes)
    }
    @IBAction func roundTapped(_ sender: UIButton) {
        HelperFuncs.showToast(message: "No have Recipes for Round cut right now", view: self.view)
    }
    
    //MARK: Live Rating
    func liveRating(navigationVC:NavigationController){
        if globalOnce{
            globalOnce = false
            let dataRef = Database.database().reference()
            
            for i in 0..<allMeatCuts!.count{
                for x in 0..<allMeatCuts![i].recipes!.count{
                    let recipe = allMeatCuts![i].recipes![x]
                    dataRef.child("UsersRate").child(recipe.id).observe(.value) { (ratingsData) in
                        
                        var ratingsAvg = 0.0
                        
                        if let ratingsData = ratingsData.value as? [String:Any]{
                            
                            for userRatingId in ratingsData.keys{
                                ratingsAvg = ratingsAvg + (ratingsData[userRatingId] as! Double)
                            }
                            ratingsAvg = ratingsAvg / Double(ratingsData.keys.count)
                            //have the updated average of a recipe.
                            //                            print("Success! recipeId \(recipe.id) add with average rating of: \(ratingsAvg)")
                        }else{
                            //                            print("Couldn't! find ratings for recipe id: \(recipe.id) set the rate to 0 (default)")
                            ratingsAvg = 1.0
                        }
                        //                        print("mainVC liverating called - avg is \(ratingsAvg)")
                        
                        navigationVC.allMeatCuts![i].recipes![x].rating = ratingsAvg
                        
                    }
                }
            }
        }
    }
}
