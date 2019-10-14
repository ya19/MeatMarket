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
        loginWithFireBaseWith()
        
    }

    @IBAction func regiserTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loginToRegistration", sender: self.allMeatCuts)
    }
    
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? NavigationController{
            guard let meatCuts = sender as? [MeatCut] else {return}
            navigationVC.allMeatCuts = meatCuts
        }
        if let registerVC = segue.destination as? RegistrationController{
            guard let meatCuts = sender as? [MeatCut] else {return}
            registerVC.allMeatCuts = meatCuts
        }
    }
    
    //MARK: funcs
    func loginWithFireBaseWith(){
        guard
          let email = emailField.text,
          let password = passwordField.text, email.count > 0, password.count > 0 else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
          if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
          }
            self.performSegue(withIdentifier: "loginToNavigation", sender: self.allMeatCuts)
        }
    }
}
