//
//  MainScreenController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

class MainScreenController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var meatCutCollectionView: UICollectionView!
    
    
    var array = ["First Cell", "Second Cell", "Third Cell", "Fourth Cell", "Fifth Cell"]
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        meatCutCollectionView.delegate = self
        meatCutCollectionView.dataSource = self
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
//        cellVisuality()
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
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeatCutCellID", for: indexPath) as! MeatCutViewCell
        cell.meatCutName.text = array[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath.row) tapped")
        performSegue(withIdentifier: "meatCutsToRecipes", sender: indexPath.row)
    }
    
//    func cellVisuality(){
//        let cellSize = CGSize(width:meatCutCollectionView.bounds.width-80, height:200)
//        let layout = UICollectionViewFlowLayout()
//
//        layout.scrollDirection = .vertical
//        layout.itemSize = cellSize
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumLineSpacing = 25
//        meatCutCollectionView.setCollectionViewLayout(layout, animated: true)
//
//        meatCutCollectionView.reloadData()
//    }
    
}


