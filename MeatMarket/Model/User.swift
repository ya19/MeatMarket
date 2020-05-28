//
//  User.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.


import UIKit
import Firebase

class User: CustomStringConvertible{
    
    //MARK: Properties
    var id:String?
    var firstName:String?
    var lastName:String?
    var email:String?
    var image:URL?
    var timeStamp: TimeInterval?
    var recipes:[Recipe]
    var myRecipes:[Recipe]?
    var description: String{
        return "id: \(id!) , firstName: \(firstName!) ,lastName: \(lastName!), Email: \(email!), timeStemp: \(String(describing: timeStamp))"
    }
    
    //MARK: Constructor
    init(){
        self.id = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.timeStamp = nil
        self.image = nil
        self.recipes = []
        self.myRecipes = []
    }
    func clear(){
        self.id = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.image = nil
        self.timeStamp = nil
        self.recipes = []
        self.myRecipes = []
    }
    
    //MARK: Load Current User Details
    func loadCurrentUserDetails(id:String, firstName:String, lastName:String, email:String, timeStemp:TimeInterval?, myRecipes:[Recipe]?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.timeStamp = timeStemp
        self.recipes = []
        self.myRecipes = myRecipes
    }
    
    //MARK: Add/Remove Favorite
    func addFavorite(recipe:Recipe){
        var alreadyHasIt = false
        for myRecipe in recipes{
            if myRecipe.id == recipe.id{
                alreadyHasIt = true
            }
        }
        if !alreadyHasIt{
            self.recipes.append(recipe)
        }
    }
    func removeFavorite(recipeId:String){
        var remember = -1
        for i in 0..<self.recipes.count{
            if self.recipes[i].id == recipeId{
                remember = i
            }
        }
        if remember != -1{
            self.recipes.remove(at: remember)
        }
    }
    //MARK: Add/Remove myRecipes
    func addRecipe(recipe:Recipe, view:UIView){
        if self.myRecipes == nil{
            self.myRecipes = []
        }
        for rec in self.myRecipes!{
            if rec.name != recipe.name {
                self.myRecipes?.append(recipe)
            }
            HelperFuncs.showToast(message: "Name recipe exist, Choose another name", view: view)
        }
        
    }
    func removeRecipe(recipe:Recipe, view:UIView){
        if self.myRecipes == nil{
            HelperFuncs.showToast(message: "You dont have recipes to delete", view: view)
        }
        for i in 0..<self.myRecipes!.count {
            if self.myRecipes![i].id == recipe.id{
                self.myRecipes!.remove(at: i)
            }
        }
    }
    
    //MARK: Set Recipe/ImageUrl
    func setRecipes(recipes:[Recipe]){
        self.recipes = recipes
    }
    func setImageUrl(url:URL?){
        self.image = url
    }
    
}


