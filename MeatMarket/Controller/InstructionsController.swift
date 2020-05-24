//
//  InstructionsController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import Firebase
import Prestyler


class InstructionsController: UIViewController, UITableViewDelegate , UITableViewDataSource{
    //MARK: Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var ratingBar: CosmosView!
    
    //MARK: Properties
    var recipe:Recipe?
    var meatCut:MeatCut?
    let dataBaseRef = Database.database().reference()
    var ratingsAvg = 0.0
    var ratingDelegate:RatingProtocol?
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsTableView.delegate = self
        instructionsTableView.dataSource = self
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        ingredientsTableView.layer.cornerRadius = 8
        instructionsTableView.layer.cornerRadius = 8
        
        self.navigationItem.title = recipe?.name

        setBarRatingWithRecipeRate()
        ratingBarTapped()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        setImageRecipe()
        //Prestler colors
        Prestyler.defineRule("^", "#CF5C36")


     }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView{
            return recipe!.ingredients.count
        }else{
            return recipe!.instructions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView{
            //Text setup
            let dotStr = "•"
            let ingredientsStr = "\(recipe?.ingredients[indexPath.row] ?? "No Ingredients")"
            let finalText = "\(dotStr) \(ingredientsStr)"
            let prefilteredText1 = finalText.prefilter(text: "•", by: "^")
            
            //cell setup
            let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCellID") as! IngredientsTableViewCell
            ingredientsCell.ingredientLable.attributedText = prefilteredText1.prestyled()
            
            return ingredientsCell
        }else{
            //create arry with all the index for present instructions order
            var counterArray:[Int] = []
            for index in 0...recipe!.instructions.count{
                counterArray.append(index)
            }
            //Text
            let preNum = "\(counterArray[indexPath.row + 1]).".prefilter(type: .numbers, by: "^").prefilter(text: ".", by: "^")
            let instructionsStr = "\(recipe?.instructions[indexPath.row] ?? "No Instructions")"
            let finalInstructionsText = "\(preNum) \(instructionsStr)"

            //Cell setup
            let instructionsCell = tableView.dequeueReusableCell(withIdentifier: "InstructionsCellID") as! InstructionsTableViewCell
            instructionsCell.instructionLable.attributedText =  finalInstructionsText.prestyled()

            return instructionsCell
        }
    }
    
    //MARK: imageRecipe and barRating
    fileprivate func setImageRecipe() {
        recipeImage.layer.cornerRadius = 8
        recipeImage.sd_setImage(with: recipe?.image)
    }
    
    fileprivate func setBarRatingWithRecipeRate() {
        let recipeRate = self.recipe!.rating
        
        self.ratingBar.text = "(\(String(format: "%.2f", recipeRate))Avg) Rate Me!"
        ratingBar.rating = recipeRate
    }
    
    fileprivate func ratingBarTapped() {
        // rating stars was tapped
        ratingBar.didTouchCosmos = { userRate in
            //TODO: save the rate of the user at the recipe.
            self.writeUsersRateToDatabase(userRate: userRate)
            HelperFuncs.showToast(message: "You Rate \(userRate)", view: self.view)
        }
    }
    
    //MARK: Write Rate to Database
    func writeUsersRateToDatabase(userRate: Double){
        guard let currentUserID = CurrentUser.shared.user?.id else {return}
        guard let recipe = recipe else {return}
        
        dataBaseRef.child("UsersRate").child(recipe.id).child(currentUserID).setValue(userRate)
        dataBaseRef.child("UsersRate").child(recipe.id).observeSingleEvent(of: .value) { (ratingsData) in
            if let ratingsData = ratingsData.value as? [String:Any]{
                for userRatingId in ratingsData.keys{
                    self.ratingsAvg = self.ratingsAvg + (ratingsData[userRatingId] as! Double)
                }
                self.ratingsAvg = self.ratingsAvg / Double(ratingsData.keys.count)
                //have the updated average of a recipe.
                //print("Success! recipeId \(recipeId) add with average rating of: \(ratingsAvg)")
            }else{
                //print("Couldn't! find ratings for recipe id: \(recipeId) set the rate to 0 (default)")
                self.ratingsAvg = 1.0
            }
            
            if let navigationVC = self.navigationController as? NavigationController {
                for i in 0..<navigationVC.allMeatCuts!.count{
                    for x in 0..<navigationVC.allMeatCuts![i].recipes!.count{
                        if recipe.id == navigationVC.allMeatCuts![i].recipes![x].id{
                            navigationVC.allMeatCuts![i].recipes![x].rating = self.ratingsAvg
                            print("rating avg is done! avg is \(self.ratingsAvg)")
                            
                            if (self.ratingDelegate != nil){
                                
                                self.ratingDelegate?.ratingAverage(rating: self.ratingsAvg)
                            }
                        }
                    }
                }
            }
            
        }
        
    }

    
    
}
