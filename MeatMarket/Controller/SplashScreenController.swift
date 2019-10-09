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
    //Actions
    @IBAction func forceMoveToLogin(_ sender: UIButton) {
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "loginStoryboardID")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    //Lifecycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    //Funcs
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
            print("----MetaData----",metadata?.name)
          }
        }
    }
    
    
    func realtimeDatabase(){
        let databaseRef = Database.database().reference()
        
        let userID = "w6KiqfBxgigl4Usx41jXql00DXL2"//need to be -> Auth.auth().currentUser?.uid
        databaseRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let data = snapshot.value as? NSDictionary
            let id = data?["id"] as? String ?? "no id"
            let email = data?["email"] as? String ?? "no email"
            let firstName = data?["firstName"] as? String ?? "no first name"
            let lastName = data?["lastName"] as? String ?? "no last name"
            
            let user = User(id: id, firseName: firstName, lastName: lastName, email: email)
            
            print("------USER----------> ",user.description)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
