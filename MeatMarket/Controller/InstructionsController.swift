//
//  InstructionsController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import SDWebImage

class InstructionsController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    
    //MARK: Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionsTableView: UITableView!
    
    //MARK: Properties
    var recipe:Recipe?
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsTableView.delegate = self
        instructionsTableView.dataSource = self
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        self.navigationItem.title = recipe?.name
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         recipeImage.layer.cornerRadius = 8
         recipeImage.sd_setImage(with: recipe?.image)
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
            let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCellID") as! IngredientsTableViewCell
            ingredientsCell.ingredientLable.text = "• \(recipe!.ingredients[indexPath.row])"
            
            return ingredientsCell
        }else{
            let instructionsCell = tableView.dequeueReusableCell(withIdentifier: "InstructionsCellID") as! InstructionsTableViewCell
            instructionsCell.instructionLable.text = "• \(recipe!.instructions[indexPath.row])"
            
            return instructionsCell
        }
        
    }
    
    
}
