//
//  User.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

class User: CustomStringConvertible{
    static let shared = User()
    var id:String?
    var firstName:String?
    var lastName:String?
    var email:String?
    var timeStamp: TimeInterval?
    var recipes:[Recipe]
    
    private init(){
        self.id = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.timeStamp = nil
        self.recipes = []
    }
    
    func loadCurrentUserDetails(id:String, firstName:String, lastName:String, email:String, timeStemp:TimeInterval?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.timeStamp = timeStemp
        self.recipes = []
        
    }
    func setRecipes(recipes:[Recipe]){
        self.recipes = recipes
    }
    var description: String{
        return "id: \(id) , firstName: \(firstName) ,lastName: \(lastName), Email: \(email), timeStemp: \(String(describing: timeStamp))"
    }
}


