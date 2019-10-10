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
    //MARK: Outlets
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    
    //MARK: Properties
    var databaseRef: DatabaseReference!
    
    //MARK: Actions
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let firstName = firstNameField.text else {return}
        guard let lastName = lastNameField.text else {return}
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        guard let verifyPassword = verifyPasswordField.text else {return}
        let timeStamp =  Date().timeIntervalSince1970
        
        if  email.count == 0 ||
            firstName.count == 0 ||
            lastName.count == 0 ||
            password.count == 0 ||
            verifyPassword.count == 0 {
            
            HelperFuncs.showToast(message: "Please Fill all the Fields", view: view)
        }else if password != verifyPassword {
            HelperFuncs.showToast(message: "Password Incompatible", view: view)
        }else{
            creatUserWith(firstName: firstName, lastName: lastName, email: email, password: password, timeStamp: timeStamp)
        
            let mainScreenVC = self.storyboard!.instantiateViewController(withIdentifier: "navigationStoryboardID")
            self.present(mainScreenVC, animated: true, completion: nil)
        }
        
    }
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let timestamp = NSDate().timeIntervalSince1970
        //        let timeStamp = Date().currentTimeMillis()
        let timeStamp =  Date().timeIntervalSince1970
        print("-----Date----",HelperFuncs.getReadableDate(timeStamp: timeStamp)!,"----timeInterval----",timeStamp)
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
    
    //MARK: Funcs

    func creatUserWith(firstName:String, lastName:String, email: String, password: String ,timeStamp: TimeInterval?){
        //Create user with Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print("-----Error Creat FireBase User----",error.localizedDescription)
            }
            Auth.auth().signIn(withEmail: email, password: password)
            print("---user LoggedIn with Firebase---")
            
            guard let id = Auth.auth().currentUser?.uid else {return}
            let userData:[String:Any?] = [
                "id": id,
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "timeStemp": timeStamp
            ]
            self.databaseRef = Database.database().reference()
            self.databaseRef.child("Users").child(id).setValue(userData)
            //Create user with User
            let user = User(id: id, firstName: firstName, lastName: lastName, email: email, timeStemp: timeStamp)
            print("----New User Created with User-----", user.description)
            

        }
    }
    
    
}

