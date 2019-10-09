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
    var firseName:String
    var lastName:String
    var email:String
    var timeStamp:CVTimeStamp?
    
    var description: String{
        return "id: \(id) , firstName: \(firseName) ,lastName: \(lastName), Email: \(email), timeStemp: \(String(describing: timeStamp))"
    }
}


