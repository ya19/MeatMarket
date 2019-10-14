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
    
    
    //MARK: Actions
    @IBAction func forceMoveToLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "splashScreenToLogin", sender: self)
    }
    
    //MARK: Properties
    var serverMeatCutsCount:Int = 0
    var allMeatCuts:[MeatCut] = []
    var allRecipesURL:[String:URL] = [:]
    var allRecipesSize = 0
    var bol:Bool = true
    
    //MARK: Lifecycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readRealTimeDatabase()
        splashScreenImageGIF.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/meat-markett.appspot.com/o/images%2Fgif%2FcowSplashScreen.gif?alt=media&token=9a3c2258-b1b3-4f8f-92f4-5aca1ad8e716"))
    }
    
    
    //MARK: Funcs
    func checkUserStateLogin(meatCuts: [MeatCut]){
        Auth.auth().addStateDidChangeListener { auth, user in
             if user != nil {
                self.performSegue(withIdentifier: "splashScreenToNavigation", sender: meatCuts)
                 
             }else{
                self.performSegue(withIdentifier: "splashScreenToLogin", sender: meatCuts)
                 
             }
             
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? NavigationController{
            guard let meatCuts = sender as? [MeatCut] else {return}
            navigationVC.allMeatCuts = meatCuts
        }
        if let loginVC = segue.destination as? LoginController{
            guard let meatCuts = sender as? [MeatCut] else {return}
            loginVC.allMeatCuts = meatCuts
        }
        
    }
    func storageDatabase(){
        let storageRef = Storage.storage().reference()
        let forestRef = storageRef.child("images/png/fillet.png")
        
        // Get metadata properties
        forestRef.getMetadata { metadata, error in
            if let error = error {
                print("-----ERROR Get MeataData-----",error.localizedDescription)
                // Uh-oh, an error occurred!
            } else {
                // Metadata now contains the metadata for 'images/forest.jpg'
                print("----MetaData----",metadata?.name ?? "---No MetaData---")
            }
        }
    }
    
    
    @objc func loadDataEvery(_ timer:Timer){

        if serverMeatCutsCount == allMeatCuts.count{
            //after get all the data need to move VC
            print("print in loadDataEvry()  -> server: \(self.serverMeatCutsCount) , allMeatCuts: \(self.allMeatCuts.count)")
            if allRecipesSize == allRecipesURL.keys.count{
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
    
    
    func readRealTimeDatabase(){
        let storageRef = Storage.storage().reference().child("images/png/")
        let storageRecipesRef = Storage.storage().reference().child("images/jpeg/")
        let databaseRef = Database.database().reference()
        let meatCutsRef = databaseRef.child("MeatCuts")
        let recipeRef = databaseRef.child("Recipes")
        meatCutsRef.observeSingleEvent(of: .value, with: { (meatCutsData) in
            self.allMeatCuts = []
            let meatCuts = meatCutsData.value as! [String:Any]
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
    
                        print(recipe.level)

                    }

                    //                    print("---All MeatCuts---",self.allMeatCuts.description)
                    
                    storageRef.child("\(cut["name"] as! String).png").downloadURL { (url, error) in
                        if let error = error {
                            print("----Error Get images from Storage----", error.localizedDescription)
                            return
                        }
//                        print("---URLS of Images------",url!.description)
                        
                        let meatCut = MeatCut(id: cut["id"] as! String,
                                                               name: cut["name"] as! String,
                                                               image: url!,
                                                               recipes: myRecipes)
                        
                        self.allMeatCuts.append(meatCut)
                    }
                    
                 
                }
            }
            print("server: \(self.serverMeatCutsCount) , allMeatCuts: \(self.allMeatCuts.count)")

            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.loadDataEvery(_:)), userInfo: nil, repeats: true)
            
        })
        
    }
}


