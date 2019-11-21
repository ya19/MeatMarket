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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMeatCuts!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let meatCutCell = collectionView.dequeueReusableCell(withReuseIdentifier: "meatCutsCellID", for: indexPath) as! MeatCutViewCell
        meatCutCell.meatCutName.text = allMeatCuts![indexPath.row].name
        meatCutCell.meatCutImageView.sd_setImage(with: allMeatCuts![indexPath.row].image)
        meatCutCell.layer.borderWidth = 2
        meatCutCell.layer.borderColor = #colorLiteral(red: 0.9611939788, green: 0.507047832, blue: 0.497117877, alpha: 1)
        return meatCutCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        performSegue(withIdentifier: "meatCutsToRecipes", sender: allMeatCuts![indexPath.row].recipes)
    }
    
    func cellVisuality(){
        let cellSize = CGSize(width:meatCutCollectionView.bounds.width * 0.8, height:meatCutCollectionView.bounds.height * 0.25)
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 25
        meatCutCollectionView.setCollectionViewLayout(layout, animated: true)

        meatCutCollectionView.reloadData()
    }
    
}


