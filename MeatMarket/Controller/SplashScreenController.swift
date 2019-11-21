//
//  File.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//
/**
    SplashScreen Preper the app to use, read from database and check the user state.
    The database readed every 0.25 sec to match the cout of the igame at the app against the count of the database
 */
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
    var bol:Bool = true
    var allRecipes:[Recipe] = []
    var splashScreenGif = "https://firebasestorage.googleapis.com/v0/b/meat-markett.appspot.com/o/images%2Fgif%2FcowSplashScreen.gif?alt=media&token=9a3c2258-b1b3-4f8f-92f4-5aca1ad8e716"
    var readCredits = false
    var credits:[String:String] = [:]
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
            guard let dictionary = sender as? [String:Any] else {return print("test")}
            navigationVC.allMeatCuts = dictionary["meatCuts"] as? [MeatCut]
            navigationVC.allRecipesURL = dictionary["allRecipesURL"] as? [String:URL]
            navigationVC.credits = dictionary["credits"] as? [String:String]
        }
        if let loginVC = segue.destination as? LoginController{
            guard let dictionary = sender as? [String:Any] else {return}
            loginVC.allMeatCuts = dictionary["meatCuts"] as? [MeatCut]
            loginVC.allRecipesURL = dictionary["allRecipesURL"] as? [String:URL]
            loginVC.credits = dictionary["credits"] as? [String:String]
        }
    }
    
    //MARK: Funcs
    
    func checkUserStateLogin(meatCuts: [MeatCut]){
        if Auth.auth().currentUser != nil {
            CurrentUser.shared.configure(userId: Auth.auth().currentUser!.uid, segueId: "splashScreenToNavigation", meatCuts: meatCuts, allRecipesURL: self.allRecipesURL, vc: self,credits: self.credits)
        }else{
            let dic:[String:Any] = ["meatCuts":meatCuts,"allRecipesURL":self.allRecipesURL,"credits":self.credits]
            self.performSegue(withIdentifier: "splashScreenToLogin", sender: dic)
        }
    }
    
    @objc func loadDataEvery(_ timer:Timer){
        
        if serverMeatCutsCount == allMeatCuts.count{
            // print("print in loadDataEvry()  -> server: \(self.serverMeatCutsCount) , allMeatCuts: \(self.allMeatCuts.count)")
            if allRecipesSize == allRecipesURL.keys.count{
                if self.readCredits == true{
                    var meatCuts:[MeatCut] = []
                    for meatCut in allMeatCuts{
                        var myMeatCut = meatCut
                        myMeatCut.recipes = []
                        for recipe in meatCut.recipes{
                            var myRecipe = recipe
                            myRecipe.image = allRecipesURL[recipe.id]
                            myMeatCut.recipes.append(myRecipe)
                        }
                        meatCuts.append(myMeatCut)
                    }
                    checkUserStateLogin(meatCuts: meatCuts)
                    
                    timer.invalidate()
                }
            }
        }
    }
    
    func readRealTimeDatabase(){
        readCredits = false
        credits = [:]
        let storageRef = Storage.storage().reference().child("images/png/")
        let storageRecipesRef = Storage.storage().reference().child("images/jpeg/")
        let databaseRef = Database.database().reference()
        let meatCutsRef = databaseRef.child("MeatCuts")
        let recipeRef = databaseRef.child("Recipes")
        
        meatCutsRef.observeSingleEvent(of: .value, with: { (meatCutsData) in
            let meatCuts = meatCutsData.value as! [String:Any]
            
            self.allMeatCuts = []
            self.serverMeatCutsCount = meatCuts.keys.count
            
            for meatCutID in meatCuts.keys{
                let cut = meatCuts[meatCutID] as! [String:Any]
                var myRecipes:[Recipe] = []
                recipeRef.child(meatCutID).observeSingleEvent(of: .value) { (recipesData) in
                    
                    let recipes = recipesData.value as! [String:Any]
                    for recipeID in recipes.keys{
                        let data = recipes[recipeID] as! [String:Any]
                        let recipe = Recipe(id: data["id"] as! String,
                                            name: data["name"] as! String,
                                            imageName: data["image"] as! String,
                                            image: nil,
                                            ingredients: data["ingredients"] as! [String],
                                            instructions: data["instructions"] as! [String],
                                            level: Levels(rawValue: data["level"] as! Int)!,
                                            time: data["time"] as! String)
                        myRecipes.append(recipe)
                        self.allRecipesSize += 1
                        storageRecipesRef.child("\(recipe.imageName).jpeg").downloadURL { (URL, Error) in
                            self.allRecipesURL[recipe.id] = URL
                        }
                    }
                    storageRef.child("\(cut["name"] as! String).png").downloadURL { (url, error) in
                        if let error = error {
                            print("----Error Get images from Storage----", error.localizedDescription)
                            return
                        }
                        let meatCut = MeatCut(id: cut["id"] as! String,
                                              name: cut["name"] as! String,
                                              image: url!,
                                              recipes: myRecipes)
                        
                        self.allMeatCuts.append(meatCut)
                    }
                }
            }
//            print("server: \(self.serverMeatCutsCount) , allMeatCuts: \(self.allMeatCuts.count)")
            Database.database().reference().child("Credits").child("RecipesCredits").observe(.value) { (creditsData) in
                guard let creditsDictionary = creditsData.value as? [String:String] else {return}
                self.credits = creditsDictionary
                self.readCredits = true
            }
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.loadDataEvery(_:)), userInfo: nil, repeats: true)
        })
    }
    
    //write all the recipes at AllRecipes for that User.shared recognaize the favorite
    //    func recipesToServer(recipe:Recipe){
    //        let ref = Database.database().reference().child("AllRecipes")
    //        let recipeValue:[String:Any] = [
    //            "id": recipe.id,
    //            "name": recipe.name,
    //            "instructions": recipe.instructions,
    //            "ingredients": recipe.ingredients,
    //            "image": recipe.imageName,
    //            "level": recipe.level.levelRecipe(),
    //            "time": recipe.time
    //        ]
    //        ref.child(recipe.id).setValue(recipeValue)
    //
    //    }
}


