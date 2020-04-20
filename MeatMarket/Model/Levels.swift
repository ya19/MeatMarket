//
//  Levels.swift
//  MeatMarket
//  Copyright © 2019 YardenSwisa. All rights reserved.

/**
 Levels - Provide to choose a level for the Recipe
 with three options Easy, Meadium, Hard.
 Levels register to the server like Int and  convert to string for display
 */
import UIKit

enum Levels:Int, CustomStringConvertible{
    
    //MARK: Cases
    case EASY = 0
    case MEDIUM = 1
    case HARD = 2

    //MARK: Properties
    var description: String{
        switch self {
        case .EASY:
            return "Easy"
        case .MEDIUM:
            return "Medium"
        case .HARD:
            return "Hard"
        }
    }
    
    //MARK: Levle Recipe
    func levelRecipe()->Int{
        switch self{
        case .EASY:
            return 0
        case .MEDIUM:
            return 1
        case .HARD:
            return 2
        }
    }

}
