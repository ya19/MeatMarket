//
//  LoginController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    //MARK: Properties
    var allMeatCuts:[MeatCut]?
    var allRecipesURL:[String:URL]?
    var credits:[String:String]?
    
    //MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        if email.count == 0 || password.count == 0{
            HelperFuncs.showToast(message: "Please Enter Email And Password", view: view)
        }
        
        loginWithFireBase()
    }
    
    @IBAction func regiserTapped(_ sender: UIButton) {
        let dic:[String:Any] = ["meatCuts": self.allMeatCuts!, "credits": self.credits!]
        self.performSegue(withIdentifier: "loginToRegistration", sender: dic)
    }
    
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let navigationVC = segue.destination as? NavigationController{
                  guard let dictionary = sender as? [String:Any] else {return print("test")}
                  navigationVC.allMeatCuts = dictionary["meatCuts"] as? [MeatCut]
                  navigationVC.allRecipesURL = dictionary["allRecipesURL"] as? [String:URL]
                 navigationVC.credits = dictionary["credits"] as? [String:String]
             }
        
        if let registerVC = segue.destination as? RegistrationController{
            guard let dictionary = sender as? [String:Any] else {return}
            registerVC.allMeatCuts = (dictionary["meatCuts"] as! [MeatCut])
            registerVC.credits = dictionary["credits"] as? [String:String]
            
        }
    }
    
    //MARK: funcs
    func loginWithFireBase(){
        guard
            let email = emailField.text,
            let password = passwordField.text, email.count > 0, password.count > 0 else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }else{
                CurrentUser.shared.configure(userId: Auth.auth().currentUser!.uid, segueId: "loginToNavigation", meatCuts: self.allMeatCuts!, allRecipesURL: self.allRecipesURL!, vc: self,credits: self.credits!)
                //            self.performSegue(withIdentifier: "loginToNavigation", sender: self.allMeatCuts)
            }
        }
    }
}
