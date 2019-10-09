//
//  ViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 08/09/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase


class SplashScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let databaseRef = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        databaseRef.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let data = snapshot.value as? NSDictionary
            let id = data?["id"] as? String ?? "no id"
            let email = data?["email"] as? String ?? "no email"
            let name = data?["firstName"] as! String
            
            let user = User(uid: id, name: name, email: email)
            
            print("------USER----------> ",user.description)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}

