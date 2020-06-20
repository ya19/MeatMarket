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

//MARK: Global Propertie 
var globalOnce = true

class MainScreenController: UIViewController{
    
    //MARK: Outlets
    @IBOutlet weak var meatCutCollectionView: UICollectionView!
    
    //MARK: Properties
    var allMeatCuts:[MeatCut]?
    var isRecipeExist = false
    var once = true
    
    

    //MARK: LifeCycle
    override func viewDidLoad() {
        print("MainScreen viewDidLoad")
        super.viewDidLoad()
        if once{
            once = false
//            observeMeatCuts()
        }
        
        print(CurrentUser.shared.user?.myRecipes ?? "none","Main myRecipes")

    }
    override func viewWillAppear(_ animated: Bool) {
        print("MainScreen viewWillAppear")
        if let navigationVC = self.navigationController as? NavigationController{
            self.allMeatCuts = navigationVC.allMeatCuts
            self.liveRating(navigationVC:navigationVC)
        }
//        print(allMeatCuts?.count,"test yossi")
        
//        print("viewWillAppear() mainScreen")
//        if let pageRootController = self.parent as? PageRootController{
//            pageRootController.loadAndSortMeatCutsMainVC()
//        }
        self.allMeatCuts!.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let recipesVC = segue.destination as? RecipesController{
            guard let recipes = sender as? [Recipe] else {return}
            recipesVC.allRecipes = recipes
            
            guard let meatCuts = sender as? [MeatCut] else {return}
            recipesVC.allMeatCuts = meatCuts
            print("finish MainScreen move to RecipesVC")
        }
        if let createRecipeVC = segue.destination as? CreateRecipeController{
            guard let allMeatCuts = sender as? [MeatCut] else {return}
            createRecipeVC.allMeatCuts = allMeatCuts
            print("finish MainScreen move to CreateRecipeVC")
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
    @IBAction func roundTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![7].recipes)
    }
    @IBAction func shankTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![8].recipes)
    }
    @IBAction func sirloinTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![9].recipes)
    }

    //MARK: Live Rating
    func liveRating(navigationVC:NavigationController){
        print("MainScreen liveRating func")
        if globalOnce{
            globalOnce = false
            let dataRef = Database.database().reference()
            
            for i in 0..<allMeatCuts!.count{
                for x in 0..<allMeatCuts![i].recipes!.count{
                    let recipe = allMeatCuts![i].recipes![x]
                    dataRef.child("UsersRate").child(recipe.id).observe(.value) { (ratingsData) in
                        var ratingsAvg = 0.0
                        ratingsAvg = HelperFuncs.calculateRecipeRating(ratingsData: ratingsData)
//                        if let ratingsData = ratingsData.value as? [String:Any]{
//                            for userRatingId in ratingsData.keys{
//                                ratingsAvg = ratingsAvg + (ratingsData[userRatingId] as! Double)
//                            }
//
//                            ratingsAvg = ratingsAvg / Double(ratingsData.keys.count)
//                        }
//
//                        ratingsAvg = 1.0
                        navigationVC.allMeatCuts![i].recipes![x].rating = ratingsAvg
                    } //observer
                }// for recipe
            }// for meatcut
        }
    }
    
    //MARK: meatCuts Observer

    func observeMeatCuts(){
        let dbRef = Database.database().reference()
//        dbRef.child("MeatCuts").observeSingleEvent(of: .value) { (meatCutsSnapShot) in
//            let meatcuts = meatCutsSnapShot.value as! [String:Any?]
//            for meatcutId in meatcuts.keys{
//                dbRef.child(<#T##pathString: String##String#>)
//            }
//        }
        dbRef.child("Recipes").observe(.childAdded) { (DataSnapshot) in
            
//            print(DataSnapshot.key.count,"childadded")
        }
    }
    
    
    //MARK: Recipes Observe
    func allRecipesObserve(){
        let allRecipesRef = FirebaseDatabase.Database.database().reference().child("AllRecipes")
        let usersRateRef = FirebaseDatabase.Database.database().reference().child("UsersRate")
        let storageRecipesRef = Storage.storage().reference().child("/images/recipesImages/")
        
        allRecipesRef.observe(.value) { (allRecipesData) in
            let allRecipes = allRecipesData.value as! [String:Any?]
            var countRecipes = 0 //test
            for recipeId in allRecipes.keys{
                countRecipes += 1 //test
                
                usersRateRef.child(recipeId).observeSingleEvent(of: .value) { (ratingsData) in
                    var ratingsAvg = 0.0
                    ratingsAvg = HelperFuncs.calculateRecipeRating(ratingsData: ratingsData)
                    print(ratingsAvg)
                    allRecipesRef.child(recipeId).observeSingleEvent(of: .value) { (DataSnapshot) in
                        let data = DataSnapshot.value as! [String:Any?]

                        var recipe = Recipe(
                            id: data["id"] as! String,
                            name: data["name"] as! String,
                            imageName: data["image"] as! String,
                            image: nil,
                            ingredients: data["ingredients"] as! [String],
                            instructions: data["instructions"] as! [String],
                            level: Levels(rawValue: data["level"] as! Int)!,
                            time: data["time"] as! String,
                            rating: ratingsAvg,
                            creator: data["creator"] as? String ?? nil,
                            meatcutID: data["meatcutID"] as! String)
                        //self.myRecipes[meatCutID]!.append(recipe)

                        storageRecipesRef.child("\(recipe.id).jpeg").downloadURL {(URL, error) in
                            if URL != nil{
                                recipe.image = URL!
                                //here i have the recipe.
                                // add methotd that checks if the recipe exists in all Meat cuts and returns true/false
                                // use the mthod here checking the recipe id and if the recipe id doesnt exist in all meatcuts then manually add here this recipe to the relevant place in the all meatcuts.
                                if self.checkRecipeInAllMeatCuts(checkRecipe: recipe){
                                    print("already exist in allMeatCuts")
                                }else{
                                    print("recipe ID: \(recipe.id) is missing and added to allMEatCuts[\("?")].recipes.append(recipe)")
                                }

                            }
                            if error != nil{
                                print(error!.localizedDescription)
                            }
                        }
                    } //observe data
                }
            }
            print(countRecipes,"countRecipes Test") //test
        }// observe
    }// end func

//    func calculateRecipeRating(ratingsData: DataSnapshot)->Double{
//        var ratingsAvg = 0.0
//        if let ratingsData = ratingsData.value as? [String:Any]{
//
//            for userRatingId in ratingsData.keys{
//                ratingsAvg = ratingsAvg + (ratingsData[userRatingId] as! Double)
//            }
//             ratingsAvg = ratingsAvg / Double(ratingsData.keys.count)
//            return ratingsAvg
//        }else{
//            //                        print("Couldn't! find ratings for recipe id: \(recipeId) set the rate to 1 (default)")
//            ratingsAvg = 1.0
//            return ratingsAvg
//        }
//    }

    //MARK: Check if recipe in allMeatCut
    func checkRecipeInAllMeatCuts(checkRecipe: Recipe)-> Bool{
        for meatcut in allMeatCuts!{
            for recipe in meatcut.recipes!{
                if checkRecipe.id+"@" == recipe.id{
                    print(checkRecipe.id , checkRecipe.name, recipe.id , recipe.name , meatcut.name)
                    isRecipeExist = true
                    return isRecipeExist
                }
            }
        }
        return isRecipeExist
    }

}
