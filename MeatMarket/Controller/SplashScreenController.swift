//
//  File.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class SplashScreenController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var splashScreenImageGIF: UIImageView!
    
    //MARK: Properties
    var serverMeatCutsCount:Int = 0
    var allMeatCuts:[MeatCut] = []
    var allRecipesURL:[String:URL] = [:]
    var allRecipesSize = 0
    var allRecipes:[Recipe] = []
    var splashScreenGif = "https://firebasestorage.googleapis.com/v0/b/meat-markett.appspot.com/o/images%2Fgif%2FcowSplashScreen.gif?alt=media&token=9a3c2258-b1b3-4f8f-92f4-5aca1ad8e716"
    var readCredits = false
    var credits:[String:String] = [:]
    var currentRecipesCount = 0
    var serverRecipesCount = 0
    var myRecipes:[String:[Recipe]] = [:]
    var currentAllMeatCuts:[String:MeatCut] = [:]
    var once = true
    
    //MARK: Lifecycle View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readRealTimeDatabase()
        splashScreenImageGIF.sd_setImage(with: URL(string: splashScreenGif))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? NavigationController{
            guard let dictionary = sender as? [String:Any] else {return}
            
            navigationVC.allMeatCuts = dictionary["meatCuts"] as? [MeatCut]
            navigationVC.allRecipesURL = dictionary["allRecipesURL"] as? [String:URL]
            navigationVC.credits = dictionary["credits"] as? [String:String]
            
            print("SplashScreen finish, loading NavigationVC")
        }
        
        if let loginVC = segue.destination as? LoginController{
            guard let dictionary = sender as? [String:Any] else {return}
            
            loginVC.allMeatCuts = dictionary["meatCuts"] as? [MeatCut]
            loginVC.allRecipesURL = dictionary["allRecipesURL"] as? [String:URL]
            loginVC.credits = dictionary["credits"] as? [String:String]
            
            print("SplashScreen finish, loading LoginVC")
        }
    }
    
    
        // MARK: RealTimeDataBase
        func readRealTimeDatabase(){
            print("readRealTimeDatabase")

            readCredits = false
            credits = [:]
            let storageRecipesRef = Storage.storage().reference().child("images/jpeg/")
            let databaseRef = Database.database().reference()
            let meatCutsRef = databaseRef.child("MeatCuts")
            let recipeRef = databaseRef.child("Recipes")
            let ratingRef = databaseRef.child("UsersRate")
            let allRecipesRef = databaseRef.child("AllRecipes")
            
            meatCutsRef.observeSingleEvent(of: .value, with: { (meatCutsData) in
                let meatCuts = meatCutsData.value as! [String:Any]
                
                self.allMeatCuts = []
                self.serverMeatCutsCount = meatCuts.keys.count
                
                for meatCutID in meatCuts.keys{
                    
                    self.myRecipes[meatCutID] = []
                    recipeRef.child(meatCutID).observeSingleEvent(of: .value) { (recipesData) in
                        
                        let recipesData = recipesData.value as! [String:Any]
    //                    print(recipesData.keys.count,"expected count")
    //                    print(recipesData.keys.count,"gggggg")
                        self.serverRecipesCount += recipesData.keys.count
                        
                        for recipeId in recipesData.keys{
                            ratingRef.child(recipeId).observe( .value, with: { (ratingsData) in
                                var ratingsAvg = 0.0
                                
                                if let ratingsData = ratingsData.value as? [String:Any]{
                                    
                                    for userRatingId in ratingsData.keys{
                                        ratingsAvg = ratingsAvg + (ratingsData[userRatingId] as! Double)
                                    }
                                    ratingsAvg = ratingsAvg / Double(ratingsData.keys.count)
                                    //have the updated average of a recipe.
                                }else{
                                    print("Couldn't! find ratings for recipe id: \(recipeId) set the rate to 1 (default)")
                                    ratingsAvg = 1.0
                                }
                                
                                if self.once{
                                    //create and add the recipe to myRecipes(contain all the recipes from the server with rating)
                                    allRecipesRef.child(recipeId).observeSingleEvent(of: .value) { (DataSnapshot) in
                                        let data = DataSnapshot.value as! [String:Any]
                                        let recipe = Recipe(id: data["id"] as! String,
                                                            name: data["name"] as! String,
                                                            imageName: data["image"] as! String,
                                                            image: nil,
                                                            ingredients: data["ingredients"] as! [String],
                                                            instructions: data["instructions"] as! [String],
                                                            level: Levels(rawValue: data["level"] as! Int)!,
                                                            time: data["time"] as! String,
                                                            rating: ratingsAvg)
                                        self.myRecipes[meatCutID]!.append(recipe)
                                        
                                        self.allRecipesSize += 1
    //                                    print(self.allRecipesSize, "all recipes size AllRecipesSize")
                                        storageRecipesRef.child("\(recipe.imageName).jpeg").downloadURL { (URL, Error) in self.allRecipesURL[recipe.id] = URL}
                                    } //observe data
                                }else{
                                        print("rate is updated \(ratingsAvg)")
                                }
                            })
                        }
                        
                        
                        let cut = meatCuts[meatCutID] as! [String:Any]
                        let meatCut = MeatCut(id: cut["id"] as! String,
                                              name: cut["name"] as! String,
                                              image: nil,
                                              recipes: nil)
                        self.currentAllMeatCuts[meatCutID] = (meatCut)
                        
                    }
                }
    //            MARK: Timer
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkRecipesCount(_:)), userInfo: nil, repeats: true)
                
                //MARK: Credits
                Database.database().reference().child("Credits").child("RecipesCredits").observe(.value) { (creditsData) in
                    guard let creditsDictionary = creditsData.value as? [String:String] else {return}
                    self.credits = creditsDictionary
                    self.readCredits = true
                }
            })
        }// realTimeDatabase
    
    //MARK: CheckUserStateLogin
    func checkUserStateLogin(meatCuts: [MeatCut]){
        print("checkUserStateLogin")
        if Auth.auth().currentUser != nil {
            self.once = false
            CurrentUser.shared.configure(userId: Auth.auth().currentUser!.uid, segueId: "splashScreenToNavigation", meatCuts: meatCuts, allRecipesURL: self.allRecipesURL, vc: self, credits: self.credits)
        }else{
            self.once = false
            let dic:[String:Any] = ["meatCuts": meatCuts,"allRecipesURL": self.allRecipesURL,"credits":self.credits]
            self.performSegue(withIdentifier: "splashScreenToLogin", sender: dic)
        }
    }
    
    @objc func loadDataEvery(_ timer:Timer){
        print("loadDataEvery")
//        print("\(serverMeatCutsCount) serverCount ///  \(allMeatCuts.count) all MeatCuts /// \(allRecipesSize) allRecipeSize /// \(allRecipesURL.keys.count) allRecipesURL")
        if serverMeatCutsCount == allMeatCuts.count{
            //TODO: check the count of the recipes from the server and the app.
            print("I AM HERE (Equals)")
            print("allRecipes \(allRecipes),,,,  allRecipesSize \(allRecipesSize),,,,  allRecipesURL.keys.count \(allRecipesURL.keys.count)")
            if allRecipesSize == serverRecipesCount{ //allRecipesURL.keys.count
                if self.readCredits == true{
                    var meatCuts:[MeatCut] = []
                    for meatCut in allMeatCuts{
                        var myMeatCut = meatCut
                        myMeatCut.recipes = []
                        for recipe in meatCut.recipes!{
                            var myRecipe = recipe
                            myRecipe.image = allRecipesURL[recipe.id]
                            myMeatCut.recipes!.append(myRecipe)
                        }
                        meatCuts.append(myMeatCut)
                    }
                    
                    checkUserStateLogin(meatCuts: meatCuts)
                    timer.invalidate()
                }
            }
        }else{
            
        }
    }
    
    @objc func checkRecipesCount(_ timer:Timer){
        print("checkRecipesCount")
        let meatCutsStorageRef = Storage.storage().reference().child("images/png/")
       
        if allRecipesSize == serverRecipesCount{
            timer.invalidate()
            for meatCutId in self.currentAllMeatCuts.keys{
                let meatCut = self.currentAllMeatCuts[meatCutId]
                meatCutsStorageRef.child("\(meatCut!.name).png").downloadURL { (url, error) in
                    if let error = error {
                        print("----Error Get images from Storage----", error.localizedDescription)
                        return
                    }
//                    print(self.myRecipes.count,"current count")
                    let meatCut = MeatCut(id: meatCut!.id,
                                          name: meatCut!.name,
                                          image: url!,
                                          recipes: self.myRecipes[meatCutId]!)
                    
                    self.allMeatCuts.append(meatCut)
                }
            }
            
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.loadDataEvery(_:)), userInfo: nil, repeats: true)
        }
    }
    

    
}


