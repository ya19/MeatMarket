//
//  PageRootController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit

class PageRootController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var viewCntrollersList:[UIViewController] = {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        
        let mainScreenVC = mainSB.instantiateViewController(withIdentifier: "mainScreenStoryboardID")
        let profileVC = mainSB.instantiateViewController(withIdentifier: "profileStoryboardID")
        let creditsVC = mainSB.instantiateViewController(withIdentifier: "creditsStoryboardID")
        
        return [mainScreenVC, profileVC, creditsVC]
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = viewCntrollersList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
