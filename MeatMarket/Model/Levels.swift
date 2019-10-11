//
//  Levels.swift
//  MeatMarket
//
//  Created by YardenSwisa on 10/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

enum Levels:Int{
    case EASY = 0
    case MEDIUM = 1
    case HARD = 2
    
    func levelRecipe(level: Levels)->Int{
        switch level{
        case .EASY:
            return 0
        case .MEDIUM:
            return 1
        case .HARD:
            return 2
        }
        
    }
}
