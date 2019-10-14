//
//  RecipesViewController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 12/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

class RecipesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK:Outlets
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    

    //MARK:Properties
    var array = ["First Cell", "Second Cell", "Third Cell", "Fourth Cell", "Fifth Cell"]

    //MARK: LiveCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCellID", for: indexPath) as! RecipeViewCell

        recipeCell.recipeNameCell.text = array[indexPath.row]
        recipeCell.recipeLevelCell.text = Levels.EASY.description
        recipeCell.recipeTimeCell.text = "1 Hour"
        recipeCell.recipeImageCell.roundCorners(.allCorners, radius: 15)
        recipeCell.recipeImageCell.image = #imageLiteral(resourceName: "testImage")
        
        return recipeCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "recipesToInstructions", sender: self)
    }
}
