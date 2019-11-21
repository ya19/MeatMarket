//
//  User.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.

/**
    CurrentUser -
 */

import UIKit
import Firebase
class CurrentUser{
    
    var allRecipes:[Recipe]
    var meatCuts:[MeatCut]
    var segueId:String
    var vc:UIViewController
    var serverFavoritesNum:Int?
    var allRecipesURL:[String:URL]
    var user:User?
    var credits:[String:String]
    var didDownloadImage = false
    var image:URL? = nil
    //MARK: Properties
    static let shared = CurrentUser()
//    var id:String?
//    var firstName:String?
//    var lastName:String?
//    var email:String?
//    var timeStamp: TimeInterval?
//    var recipes:[Recipe]

    
    //MARK: Constructor
    private init(){
        user = User()
        allRecipes = []
        meatCuts = []
        segueId = ""
        credits = [:]
        vc = UIViewController()
        serverFavoritesNum = nil
        allRecipesURL = [:]
    }
    
    //MARK: Funcs
    func logout(){
        credits = [:]

        user!.clear()
           allRecipes = []
           meatCuts = []
           segueId = ""
           vc = UIViewController()
           serverFavoritesNum = nil
           allRecipesURL = [:]
    }
    

    
    func configure(userId:String,segueId:String,meatCuts:[MeatCut],allRecipesURL:[String:URL],vc:UIViewController,credits:[String:String]){
        print("configure called")
        let dataBaseRef = Database.database().reference()
        self.segueId = segueId
        self.vc = vc
        self.allRecipesURL = allRecipesURL
        self.meatCuts = meatCuts
        self.allRecipes = []
        self.credits = credits
        self.image = nil
        self.didDownloadImage = false
        self.serverFavoritesNum = nil
        let storageRef = Storage.storage().reference(forURL: "gs://meat-markett.appspot.com/images/profileImage/")
        let imageRef = storageRef.child(userId)

        imageRef.downloadURL { url, error in
          if let error = error {
            print(error.localizedDescription)
            self.didDownloadImage = true
          } else {
            if url != nil{
                self.image = url
                print(url)
            }
            self.didDownloadImage = true
          }
        }
            dataBaseRef.child("Users").child(userId).observeSingleEvent(of: .value) { (userData) in
                guard let userDictionary = userData.value as? [String:Any] else {return}
                self.user!.loadCurrentUserDetails(id: userId,
                                                   firstName: userDictionary["firstName"] as! String,
                                                   lastName: userDictionary["lastName"] as! String,
                                                   email: userDictionary["email"] as! String,
                                                   timeStemp: nil)
                dataBaseRef.child("Favorites").child(userId).observeSingleEvent(of: .value, with: { (userFavoritesData) in
                    guard let userFavoritesData = userFavoritesData.value as? [String:Any] else {
                        self.serverFavoritesNum = 0
                        self.allRecipes = []
                        return
                    }
                    self.serverFavoritesNum = userFavoritesData.keys.count
                    self.allRecipes = []
                    print(userFavoritesData.keys)
                    for recipeId in userFavoritesData.keys{
                        dataBaseRef.child("AllRecipes").child(recipeId).observeSingleEvent(of: .value) { (recipeData) in
                            guard let recipeData = recipeData.value as? [String:Any] else {return}
                            let recipe = Recipe(id: recipeData["id"] as! String,
                                                name: recipeData["name"] as! String,
                                                imageName: recipeData["image"] as! String,
                                                image: allRecipesURL[recipeId],
                                                ingredients: recipeData["ingredients"] as! [String],
                                                instructions: recipeData["instructions"] as! [String],
                                                level: Levels(rawValue: (recipeData["level"] as! Int))!,
                                                time: recipeData["time"] as! String)
                            self.allRecipes.append(recipe)
                            print(userFavoritesData.keys.count)
                        }
                    }
                })
              
            }
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.loadUser(_:)), userInfo: nil, repeats: true)

    }
    
    @objc func loadUser(_ timer:Timer){
//        print(serverFavoritesNum?,allRecipes.count)
        
        if serverFavoritesNum != nil , serverFavoritesNum == allRecipes.count, didDownloadImage{
            timer.invalidate()
            self.user!.setImageUrl(url: self.image)
            self.user!.setRecipes(recipes: allRecipes)
            let dic:[String:Any] = ["meatCuts":self.meatCuts,"allRecipesURL":self.allRecipesURL,"credits":self.credits]
            vc.performSegue(withIdentifier: segueId, sender: dic)
        }
     
    }
    
    
    func addToFavorite(recipe:Recipe,vc:UIViewController,delegate:RecipeCellFavoriteStatusDelegate){
     Database.database().reference().child("Favorites").child(user!.id!).child(recipe.id).setValue(ServerValue.timestamp()) { (Error, DatabaseReference) in
            delegate.changeStatus()
        }
        user!.addFavorite(recipe: recipe)
        HelperFuncs.showToast(message: "added to favorites", view: vc.view)
    }
    func removeFromFavorite(recipe:Recipe,vc:UIViewController,delegate:Any){
        Database.database().reference().child("Favorites").child(user!.id!).child(recipe.id).removeValue { (Error, DatabaseReference) in
            if let delegate = delegate as? RecipeCellFavoriteStatusDelegate{
                delegate.changeStatus()
            }
            if let delegate = delegate as? RemoveFavoriteProtocol{
                delegate.refresh(recipeId: recipe.id)
            }
        }
        user!.removeFavorite(recipeId: recipe.id)
        HelperFuncs.showToast(message: "removed from favorites", view: vc.view)
    }
}


