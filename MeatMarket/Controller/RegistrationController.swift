//
//  RegistrationController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    //Outlets
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    
    //Actions
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailField.text else {return}
        if email.count == 0{
            HelperFuncs.showToast(message: "test Toast Show", view: view)
        }
    }
    
    //LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func creatUserFirebaseWith(email: String, password: String){
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print("-----Error Creat FireBase User----",error.localizedDescription)
            }
            Auth.auth().signIn(withEmail: email, password: password)
            
            let mainScreenVC = self.storyboard!.instantiateViewController(withIdentifier: "mainScreenStoryboardID")
            self.present(mainScreenVC, animated: true, completion: nil)
//          if error == nil {
//            // 3
//
//          }
        }
    }
    

}
