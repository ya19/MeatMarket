//
//  CreditsController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase
class CreditsController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreditsCellDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var creditsTableView: UITableView!
    
    
    //MARK: Properties
    var creditsArray:[String] = []
//        [
//            [
//                "Honey paprika glazed steak onions",
//                "Plate short rib smoked",
//                "Grilled Porterhouse with Romesco",
//                "Fillet Rosmary",
//                "Black pepper-crusted beef fillet",
//                "Beef Fillet with Salsa Verde",
//                "BEEF SIRLOIN WITH FRESH HERB MARINADE",
//                "Ribeye Garlic Marinated Steaks",
//                "Texas Ribeye",
//                "Best Marinade Ribeye",
//                "SLOW-COOKED BEEF SHORT RIBS",
//                "Smoky Brisket",
//                "BBQ Brisket",
//                "Grilled Chimichurri Flank",
//                "Honey Soy Flank",
//                "ITALIAN STUFFED FLANK STEAK",
//                "Beer And Onion Shank Steak",
//                "Shank Osso Bucco",
//                "Shank With Polenta",
//                "Koriean chuck",
//                "Pot Roast(chuck) and Potatoes",
//                "Garlic and herb sirloin",
//                "Strip Sirloin Over Rice "
//            ]
//    ,
//            [
//                "Image NAme 1",
//                "Image Name 2",
//                "image Name 3",
//                "Image Name 4"
//            ]
//        ]
    var urlArray:[String] = []
//        "http://www.eatingwell.com/recipe/258509/honey-paprika-glazed-steak-onions/",
//        "https://www.weber.com/AU/en/recipes/red-meat/beef-short-ribs/weber-203881.html",
//        "https://www.williams-sonoma.com/recipe/grilled-porterhouse-with-romesco.html",
//        "https://simply-delicious-food.com/rosemary-crusted-beef-fillet-with-horseradish-cream/",
//        "https://www.goodfood.com.au/recipes/black-peppercrusted-beef-fillet-20111018-29v57",
//        "https://www.lifestylefood.com.au/recipes/22594/beef-fillet-with-salsa-verde",
//        "https://paleoleap.com/beef-sirloin-fresh-herb-marinade/",
//        "https://www.allrecipes.com/recipe/17325/savory-garlic-marinated-steaks/?internalSource=hub%20recipe&referringId=1028&referringContentType=Recipe%20Hub",
//        "https://www.myfoodandfamily.com/recipe/074710/texas-ribeye-recipe",
//        "https://www.food24.com/Recipes-and-Menus/Holiday/Best-marinated-rib-eye-steak-20151016-2",
//        "https://www.gordonramsay.com/gr/recipes/slow-cooked-beef-short-ribs/",
//        "https://www.taste.com.au/recipes/smoky-beef-brisket/22aedde6-1b4e-4e61-807f-b77903c39a2f",
//        "https://realfood.tesco.com/recipes/bbq-beef-brisket.html",
//        "https://www.wenthere8this.com/grilled-flank-steak/",
//        "https://www.splendidtable.org/recipes/honey-soy-flank-steak",
//        "https://www.thechunkychef.com/italian-stuffed-flank-steak/",
//        "http://mymansbelly.com/2015/01/16/beer-and-onion-braised-beef-shank-recipe/",
//        "https://www.rosalynndaniels.com/beef-shank-osso-bucco/",
//        "https://firsthandfoods.com/2019/01/21/braised-beef-shank-with-polenta/",
//        "https://damndelicious.net/2015/02/21/slow-cooker-korean-beef/",
//        "https://www.lecremedelacrumb.com/instant-pot-pot-roast-potatoes/",
//        "https://therecipecritic.com/garlic-butter-herb-steak-bites/",
//        "https://www.tasteofhome.com/recipes/sirloin-strips-over-rice/"
//    ]
    
    var credits:[String:String]?
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
//        toServer()
       
    }
    override func viewWillAppear(_ animated: Bool) {
         if let navigationVC = self.navigationController as? NavigationController{
               credits = navigationVC.credits
        }
    }
    func loadCredits(){
        for creditName in credits!.keys{
            creditsArray.append(creditName)
            urlArray.append(credits![creditName]!)
        }
    }
//    func toServer(){
//        var dic:[String:String] = [:]
//        for i in 0..<urlArray.count{
//            dic[creditsArray[0][i]] = urlArray[i]
//        }
//        Database.database().reference().child("Credits").child("RecipesCredits").setValue(dic)
//
//    }
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recipes"
        case 1:
            return "Images"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        credits!.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let creditsCell = tableView.dequeueReusableCell(withIdentifier: "creditsCellID") as! CreditsTableViewCell
        
        creditsCell.populate(recipeName:creditsArray[indexPath.row])
        creditsCell.creditCellDelegate = self
        creditsCell.websiteBtn.tag = indexPath.row
        setupCreditTable(tableView: tableView)

        return creditsCell
    }
    func setupCreditTable(tableView: UITableView){
        tableView.layer.cornerRadius = 13
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 0.5)
    }
    
    //MARK: Protocols
//    func openWebSiteTapped(){
//
//    }
}
