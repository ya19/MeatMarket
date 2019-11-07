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
    var urlArray:[String] = []
    var credits:[String:String]?

    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCredits()
    }
    
    //MARK: TableView
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Recipes"
//        case 1:
//
//        default:
//            return ""
//        }
        return "Recipes"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creditsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let creditsCell = tableView.dequeueReusableCell(withIdentifier: "creditsCellID") as! CreditsTableViewCell
        
        creditsCell.populate(recipeName:creditsArray[indexPath.row])
        creditsCell.creditCellDelegate = self
        creditsCell.websiteBtn.tag = indexPath.row
//        setupCreditTable(tableView: tableView)

        return creditsCell
    }
    func setupCreditTable(tableView: UITableView){
        tableView.layer.cornerRadius = 13
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 0.5)
    }
    
    //MARK: Funcs
    func loadCredits(){
        for creditName in credits!.keys{
            creditsArray.append(creditName)
            urlArray.append(credits![creditName]!)
        }
    }
}
