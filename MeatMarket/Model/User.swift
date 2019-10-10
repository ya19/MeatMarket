//
//  User.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

struct User: CustomStringConvertible{
    
    var id:String
    var firstName:String
    var lastName:String
    var email:String
    var timeStamp: TimeInterval?
    
    init(id:String, firstName:String, lastName:String, email:String, timeStemp:TimeInterval?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.timeStamp = timeStemp
        
        
    }
    var description: String{
        return "id: \(id) , firstName: \(firstName) ,lastName: \(lastName), Email: \(email), timeStemp: \(timeStamp)"
    }
}


