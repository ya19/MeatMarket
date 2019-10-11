//
//  Recipe.swift
//  MeatMarket
//
//  Created by YardenSwisa on 10/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

struct Recipe{
    let id:String
    let name:String
    let image:String
    let ingredients:[String]
    let instructions:[String]
    let level:Levels
    let time:String
}
