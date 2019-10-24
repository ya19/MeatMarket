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
            guard let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "loginStoryboardID") as? LoginController else {return}
            guard let navigationVC = self.navigationController as? NavigationController else {return}
            loginVC.allMeatCuts = navigationVC.allMeatCuts
            loginVC.allRecipesURL = navigationVC.allRecipesURL
            CurrentUser.shared.logout()
            self.present(loginVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            HelperFuncs.showToast(message: signOutError.localizedDescription, view: view)
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: Properties
    lazy var viewCntrollersList:[UIViewController] = {
        
        let mainScreenVC = self.storyboard!.instantiateViewController(withIdentifier: "mainScreenStoryboardID") as! MainScreenController
        let profileVC = self.storyboard!.instantiateViewController(withIdentifier: "profileStoryboardID") as! ProfileController
        let creditsVC = self.storyboard!.instantiateViewController(withIdentifier: "creditsStoryboardID") as! CreditsController
        
        return [mainScreenVC, profileVC, creditsVC]
    }()
    
    var pageControl = UIPageControl()
    
   

    
    //MARK: LifeCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = viewCntrollersList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        self.navigationItem.title = "Meat Cuts"
        configurePageControl()
    }
    
    //MARK: PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewCntrollersList.firstIndex(of: viewController) else {return nil}
        let previusIndex = vcIndex - 1
        setTitle(vcIndex: previusIndex)
        guard previusIndex >= 0 else {return nil}
        guard viewCntrollersList.count > previusIndex else {return nil}
        if previusIndex == 1{
                  let profileVC = viewCntrollersList[previusIndex] as! ProfileController
            if profileVC.favoriteCollectionView != nil{
                  profileVC.favoriteCollectionView.reloadData()
            }
        }else if previusIndex == 0{
            let mainVC = viewCntrollersList[previusIndex] as! MainScreenController
            if mainVC.meatCutCollectionView != nil{
                mainVC.meatCutCollectionView.reloadData()
            }
        }
        return viewCntrollersList[previusIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewCntrollersList.firstIndex(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        setTitle(vcIndex: nextIndex)
        guard viewCntrollersList.count != nextIndex else {return nil}
        guard viewCntrollersList.count > nextIndex else {return nil}
        if nextIndex == 1{
            let profileVC = viewCntrollersList[nextIndex] as! ProfileController
            if profileVC.favoriteCollectionView != nil{
                profileVC.favoriteCollectionView.reloadData()
            }
        }else if nextIndex == 0{
            let mainVC = viewCntrollersList[nextIndex] as! MainScreenController
            if mainVC.meatCutCollectionView != nil{
                mainVC.meatCutCollectionView.reloadData()
            }
        }
        return viewCntrollersList[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewCntrollersList.firstIndex(of: pageContentViewController)!
    }
    
    //MARK: Page Control
    func configurePageControl() {
        let positionX = UIScreen.main.bounds.width / 2 - 25
        let positionY = UIScreen.main.bounds.maxY - 45
        let width = CGFloat(50)
        let height = CGFloat(40)
        pageControl = UIPageControl(frame: CGRect(x: positionX,y: positionY,width: width,height: height))
        self.pageControl.numberOfPages = viewCntrollersList.count
        self.pageControl.currentPage = viewCntrollersList.startIndex
        self.pageControl.alpha = 1
//        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.view.addSubview(pageControl)
    }
    
    func setTitle(vcIndex:Int){
        switch vcIndex{
        case 0:
            self.navigationItem.title = "Meat Cuts"
            break
        case 1:
            self.navigationItem.title = "Profile"
            break
        case 2:
            self.navigationItem.title = "Credits"
            break
        default:
            return
        }
    }
}
