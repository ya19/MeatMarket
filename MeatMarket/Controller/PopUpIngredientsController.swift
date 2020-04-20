//
//  PopUpIngredientsViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 11/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit


class PopUpIngredientsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var ingredientsTV: UITableView!
    @IBOutlet weak var ingredientsTF: UITextField!
    
    var userIngredient =  ""
    var userIngredients:[String] = []
    var counterForIngredients = 0
    
    //MARK: LifeSycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTV.delegate = self
        ingredientsTV.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: Actions
    @IBAction func addIngredientTapped(_ sender: UIButton) {
        if ingredientsTF.text?.count != 0{
            counterForIngredients += 1
            userIngredient = ingredientsTF.text!
            userIngredients.append(userIngredient)
            ingredientsTF.text = ""

        }else{
            HelperFuncs.showToast(message: "Please enter Ingredient", view: self.view)
        }
        ingredientsTV.reloadData()
        print(userIngredients)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "createIngrediwntsCellID") as! CreateRecipeIngredientsTableViewCell
        cell.labelCell.text = "\(counterForIngredients). \(userIngredients[indexPath.row])"
        
        return cell
    }
    
    
}
