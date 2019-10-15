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
    @IBOutlet weak var meatCutCollectionView: UICollectionView!
    
    var allMeatCuts:[MeatCut]?
    var array = ["First Cell", "Second Cell", "Third Cell", "Fourth Cell", "Fifth Cell"]
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height * 0.3)
//
//    }
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
        let cellSize = CGSize(width:meatCutCollectionView.bounds.width-80, height:200)
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 25
        meatCutCollectionView.setCollectionViewLayout(layout, animated: true)

        meatCutCollectionView.reloadData()
    }
    
}


