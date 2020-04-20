//
//  ExtentionCreateRecipePicker.swift
//  MeatMarket
//
//  Created by YardenSwisa on 06/04/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit

extension CreateRecipeController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allMeatCuts!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userRecipeMeatCut = allMeatCuts![row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allMeatCuts![row].name
    }
}
