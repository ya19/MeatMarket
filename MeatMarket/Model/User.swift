//
//  User.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

struct User: CustomStringConvertible{
    
    var uid:String
    var name:String
    var email:String
    
    var description: String{
        return "UID: \(uid) , Name: \(name) , Email: \(email)"
    }
}


