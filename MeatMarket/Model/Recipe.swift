//
//  Recipe.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.

import UIKit

struct Recipe: Equatable{
    
    //MARK: Properties
    let id:String
    let name:String
    let imageName:String
    var image:URL?
    let ingredients:[String]
    let instructions:[String]
    let level:Levels
    let time:String
    var rating:Double
    var creator:String?
}
