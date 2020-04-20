//
//  CreateRecipeController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 03/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit



class CreateRecipeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var meatCutPicker: UIPickerView!
    @IBOutlet weak var recipeNameTF: UITextField!
    @IBOutlet weak var levelSegment: UISegmentedControl!
    @IBOutlet weak var recipeTimeTF: UITextField!
    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var instructionsBtn: UIButton!
    @IBOutlet weak var recipeImageIV: UIImageView!
    
    //MARK: Properties
    var allMeatCuts:[MeatCut]?
    var userRecipeMeatCut = ""
    var userRecipeName = ""
    var userRecipeTime = ""
    var userRecipeLevel:Levels = .EASY
    var userRecipeImageName = ""
    var userRecipeIngredients:[String] = []
    var userRecipeInstractions:[String] = []
    var userRecipeImage:UIImage? = nil
    let picker = UIPickerView()
    
    
    //MARK: LifeSycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
        self.observeKeybordForPushUpTheView()
        self.hideKeyboardWhenTappedAround()

    }
    

    
    //MARK: Actions
    @IBAction func recipeLevelSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            userRecipeLevel = Levels.EASY
            break
        case 1:
            userRecipeLevel = Levels.MEDIUM
            break
        case 2:
            userRecipeLevel = Levels.HARD
            break
        default:
            userRecipeLevel = Levels.EASY
        }
    }

    @IBAction func recipePictureTapped(_ sender: UIButton) {
        // select picture from device
        print("Pick image for Recipe")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose Source Camera or Library", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }else{
                HelperFuncs.showToast(message: "Camera not Available", view: self.view)
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func ingredientsTapped(_ sender: UIButton) {
        
        print("Add Ingredients for the recipe")
        
    }
    
    @IBAction func instructionsTapped(_ sender: UIButton) {
        
        print("Add Instruction for the recipe")
        
    }
    
    @IBAction func createRecipeTapped(_ sender: UIButton) {
        checkFildsText()
        
        print("\(userRecipeMeatCut)")
        print("\(userRecipeName)")
        print("\(userRecipeTime)")
        print("\(userRecipeImage!.description)")
        print("\(userRecipeLevel)")
//        print("Create User Recipe")
        
    }
    

    //MARK: Picker Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        recipeImageIV.image = image
        userRecipeImage = image
        
        dismiss(animated: true)
    }
    
    //MARK: Check user filds
    fileprivate func checkFildsText() {
        if recipeNameTF.text != nil{
            userRecipeName = recipeNameTF.text!
        }else{
            HelperFuncs.showToast(message: "Please enter recipe name", view: self.view)
        }
        
        if recipeTimeTF.text != nil{
            userRecipeTime = recipeTimeTF.text!
        }else{
            HelperFuncs.showToast(message: "Please enter recipe time", view: self.view)
        }
    }
}



class PopUpInstructionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var instructionTF: UITextField!
    @IBOutlet weak var instructionsTV: UITableView!
    
    //MARK: Properties
    var userInstruction =  ""
    var userInstructions:[String] = []
    var counterForInstruction = 0
    let a = ["a","as","asd","asdf","asdfg"]
    
    //MARK: LifeSycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsTV.delegate = self
        instructionsTV.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
        
        
    }
    
    //MARK: Actions
    @IBAction func addInstructionTapped(_ sender: UIButton) {
        if instructionTF.text?.count != 0{
            counterForInstruction += 1
            userInstruction = instructionTF.text!
            userInstructions.append(userInstruction)
            instructionTF.text = ""
            
        }else{
            HelperFuncs.showToast(message: "Please enter Instraction", view: self.view)
        }
        
        print(userInstructions)
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInstructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! CreateRecipeInstrcuctionTableViewCell

        cell.backgroundColor = .blue
        cell.instructionCellLabel.text = "• \(a[indexPath.row])"
        cell.instructionCellLabel.backgroundColor = .green

        return cell
    }
    
    
}




