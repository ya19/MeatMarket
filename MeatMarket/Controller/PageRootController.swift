//
//  PageRootController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import Firebase

class PageRootController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: Actions
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            UserDefaults.standard.set("0", forKey: "isLogin")
            let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "loginStoryboardID")
            self.present(loginVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: Properties
    lazy var viewCntrollersList:[UIViewController] = {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        
        let mainScreenVC = mainSB.instantiateViewController(withIdentifier: "mainScreenStoryboardID")
        let profileVC = mainSB.instantiateViewController(withIdentifier: "profileStoryboardID")
        let creditsVC = mainSB.instantiateViewController(withIdentifier: "creditsStoryboardID")
        
        return [mainScreenVC, profileVC, creditsVC]
    }()
    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = viewCntrollersList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    

    //MARK: Funcs
    
    
    //MARK: PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewCntrollersList.firstIndex(of: viewController) else {return nil}
        let previusIndex = vcIndex - 1
        guard previusIndex >= 0 else {return nil}
        guard viewCntrollersList.count > previusIndex else {return nil}
        
        return viewCntrollersList[previusIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewCntrollersList.firstIndex(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewCntrollersList.count != nextIndex else {return nil}
        guard viewCntrollersList.count > nextIndex else {return nil}
        
        return viewCntrollersList[nextIndex]
    }
}
