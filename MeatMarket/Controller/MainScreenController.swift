//
//  MainScreenController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import SDWebImage

class MainScreenController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: Outlets
    @IBOutlet weak var meatCutCollectionView: UICollectionView!
    
    //MARK: Properties
    var allMeatCuts:[MeatCut]?

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meatCutCollectionView.delegate = self
        meatCutCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navigationVC = self.navigationController as? NavigationController{
            self.allMeatCuts = navigationVC.allMeatCuts
        }
        cellVisuality()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipesController{
            guard let recipes = sender as? [Recipe] else {return}
            recipesVC.allRecipes = recipes
        }
    }
    
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMeatCuts!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meatCutsCellID", for: indexPath) as! MeatCutViewCell
        cell.meatCutName.text = allMeatCuts![indexPath.row].name
        cell.meatCutImageView.sd_setImage(with: allMeatCuts![indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![indexPath.row].recipes)
    }
    
    func cellVisuality(){
        let cellSize = CGSize(width:meatCutCollectionView.bounds.width * 0.9, height:meatCutCollectionView.bounds.height * 0.22)
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 25
        meatCutCollectionView.setCollectionViewLayout(layout, animated: true)

        meatCutCollectionView.reloadData()
    }
    
}


