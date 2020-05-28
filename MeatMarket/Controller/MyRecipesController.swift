//
//  MyRecipesController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 28/05/2020.
//  Copyright © 2020 YardenSwisa. All rights reserved.
//

import UIKit


class MyRecipesController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    
    @IBOutlet weak var myRecipesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRecipesCollectionView.delegate = self
        myRecipesCollectionView.delegate = self
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myRecipesCellID", for: indexPath) as! MyRecipesViewCell
        
        cell.layer.cornerRadius = 10
        
        cell.imageView.image =  UIImage(named: "image_is_missing")
        cell.levelTextField.text = Levels.EASY.description
        cell.nameTextField.text = "The Recipe Name"
        cell.timeTextField.text = "40 mins"
        cell.backgroundColor = .cyan
        
        return cell
    }
}
