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
    //MARK: Actions
    @IBAction func forceMoveToLogin(_ sender: UIButton) {
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "loginStoryboardID")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    //MARK: Properties
    var serverMeatCutsCount:Int = 0
    var allMeatCuts:[MeatCut] = []
    var allRecipes:[Recipe] = []
    
    //MARK: Lifecycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        readRealTimeDatabase()
        print("---All MeatCuts---",allMeatCuts.description)
    }
    
    
    //MARK: Funcs
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
            timer.invalidate()
        }
    }
    func readRealTimeDatabase(){
        let storageRef = Storage.storage().reference().child("images/png/")
        let databaseRef = Database.database().reference()
        let meatCutsRef = databaseRef.child("MeatCuts")
        let recipeRef = databaseRef.child("Recipes")
        meatCutsRef.observeSingleEvent(of: .value, with: { (meatCutsData) in
            self.allMeatCuts = []
            let meatCuts = meatCutsData.value as! [String:Any]
            self.serverMeatCutsCount = meatCuts.keys.count
            
            for meatCutID in meatCuts.keys{
                let cut = meatCuts[meatCutID] as! [String:Any]
                
                recipeRef.child(meatCutID).observeSingleEvent(of: .value) { (recipesData) in
                    self.allRecipes = []
                    let recipes = recipesData.value as! [String:Any]
                    
                    for recipeID in recipes.keys{
                        let data = recipes[recipeID] as! [String:Any]
                        let recipe = Recipe(id: data["id"] as! String,
                                            name: data["name"] as! String,
                                            image: data["image"] as! String,
                                            ingredients: data["ingredients"] as! [String],
                                            instructions: data["instructions"] as! [String],
                                            level: Levels(rawValue: data["level"] as! Int)!,
                                            time: data["time"] as! String)
                        self.allRecipes.append(recipe)
                    }
                    storageRef.child("\(cut["name"] as! String).png").downloadURL { (url, error) in
                        if let error = error {
                            print("----Error Get images from Storage----", error.localizedDescription)
                        }
                        print("---URLS of Images------",url!.description)
                        
                    }
//                    print("----Stirage.child.name----",storageRef.child("name"))
                    
                    let meatCut = MeatCut(id: cut["id"] as! String,
                        name: cut["name"] as! String,
                        image: cut["imageName"] as! String,
                        recipes: self.allRecipes)
                    self.allMeatCuts.append(meatCut)
                }
            }
        })
            
    }
    
        //Ceack Database
//    func realtimeDatabase(){
//        let databaseRef = Database.database().reference()
//
//        let userID = "w6KiqfBxgigl4Usx41jXql00DXL2"//need to be -> Auth.auth().currentUser?.uid
//        databaseRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let data = snapshot.value as? NSDictionary
//            let id = data?["id"] as? String ?? "no id"
//            let email = data?["email"] as? String ?? "no email"
//            let firstName = data?["firstName"] as? String ?? "no first name"
//            let lastName = data?["lastName"] as? String ?? "no last name"
//            let timeStemp = data?["timeStemp"] as? TimeInterval
//
//            let user = User(id: id, firstName: firstName, lastName: lastName, email: email, timeStemp: timeStemp)
//
//            print("------USER----------> ",user.description)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    
}


