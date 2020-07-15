//
//  CreateRecipeIngredientsViewCell.swift
//  MeatMarket
//
//  Created by YardenSwisa on 11/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit

class CreateRecipeIngredientsTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var labelCell: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        setupVisualy()
    }
    
    func setupVisualy(){
        labelCell.textColor = .darkGray
        contentView.backgroundColor = .clear
    }
    

}

