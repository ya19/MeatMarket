//
//  NavigationController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class NavigationController: UINavigationController {
    //MARK: Properties
//    var allMeatCuts:[MeatCut]?
    var allRecipesURL:[String:URL]?
    var credits:[String:String]?
    var isRecipeExist = false
    var count = 0
    var recipeMeatcut = 0
    var meatcutIndex = -1
    
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
         print("navigationVC viewDidLoad")
//        allRecipesObserve()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("navigationVC viewWillAppear")
    }

        //MARK: Recipes Observe
        func allRecipesObserve(){
            print("navigationVC allRecipesObserve")
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
                        
                        if let ratingsData = ratingsData.value as? [String:Any]{
                            
                            for userRatingId in ratingsData.keys{
                                ratingsAvg = ratingsAvg + (ratingsData[userRatingId] as! Double)
                            }
                            ratingsAvg = ratingsAvg / Double(ratingsData.keys.count)
                        }else{
                            //                        print("Couldn't! find ratings for recipe id: \(recipeId) set the rate to 1 (default)")
                            ratingsAvg = 1.0
                        }
                        
    //                    allRecipesRef.child(recipeId).observeSingleEvent(of: .value) { (DataSnapshot) in
                            
    //                        let data = DataSnapshot.value as! [String:Any?]
                        let data = allRecipes[recipeId] as! [String:Any?]
                            var recipe = Recipe(
                                id: data["id"] as! String,
                                name: data["name"] as! String,
                                imageName: data["image"] as! String,
                                image: nil,
                                ingredients: data["ingredients"] as! [String],
                                instructions: data["instructions"] as! [String],
                                level: Levels(rawValue: data["level"] as! Int)!,
                                time: data["time"] as! String,
                                rating: ratingsAvg ,
                                creator: data["creator"] as? String ?? nil,
                                meatcutID: data["meatcutID"] as! String)
    //                        self.myRecipes[meatCutID]!.append(recipe)
                            
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
    //                                    if self.meatcutIndex != -1{
                                        // need to bring the right meatcut index or id and add the recipe at that meatcut
                                        MyData.shared.allMeatCuts[0].recipes!.append(recipe)
    //                                    }
                                    }
                                    
                                }
                                if error != nil{
                                    print(error!.localizedDescription)
                                }
                            }
    //                    } //observe data
                    }
                }
//                print(countRecipes,"countRecipes Test") //test
            }// observe
        }// end func
        
        
        //MARK: Check if recipe in allMeatCut
        func checkRecipeInAllMeatCuts(checkRecipe: Recipe)-> Bool{
            print("navigationVC checkRecipeInAllMeatCuts")
            for i in 0..<MyData.shared.allMeatCuts.count{
                let meatcut = MyData.shared.allMeatCuts[i]
                for recipe in meatcut.recipes!{
                    if checkRecipe.id == recipe.id{
                        print(checkRecipe.id , checkRecipe.name, recipe.id , recipe.name , meatcut.name)
                        isRecipeExist = true
                        return isRecipeExist
                    }
                    
                }
                if(i == 0){
                    print(meatcut.name,"____meatcutname____add the new recipe here____")
                }
            }
            return isRecipeExist
        }
    
}
