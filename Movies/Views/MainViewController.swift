//
//  MainViewController.swift
//  Movies
//
//  Created by Secrieru Andrei on 17.11.2022.
//

import UIKit

class MainViewController: UITabBarController {
    //MARK: - Properties
    
    let singleVc = SingleViewController()
    let favoritesVc = FavoritesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabView()
        self.navigationItem.title = "Movies"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: singleVc.switchControl)
        self.setViewControllers([singleVc,favoritesVc], animated: true)
        singleVc.viewModel.fetchIdFromUserDefaults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        singleVc.viewModel.saveData()
    }
}

//MARK: - SetUpTabView

typealias MainViewControllerSetUp = MainViewController
extension MainViewControllerSetUp {
    func setUpTabView() {
        setUpTabViewItems()
        setUpTabBar()
    }
    
    func setUpTabBar() {
        let posX: CGFloat = 16
        let posY: CGFloat = 16
        let width = tabBar.bounds.width - posX * 2
        let height = tabBar.bounds.height + posY * 2
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: posX, y: tabBar.bounds.minY - posY, width: width, height: height),
                                      cornerRadius: height / 2)
        roundLayer.path = bezierPath.cgPath
        roundLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.9039735099)
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .white
    }
    
    func setUpTabViewItems() {
        singleVc.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "house.fill"), tag: 1)
        favoritesVc.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
    }
}

//MARK: - Data Control

typealias MainViewControllerDataControl = MainViewController
extension MainViewControllerDataControl {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 2 {
            favoritesVc.viewModel = singleVc.viewModel
            animate()
            self.navigationItem.title = "Favorites"
            self.navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            self.navigationItem.title = "Movies"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: singleVc.switchControl)
            animate()
        }
    }
}

//MARK: - Aniamtion

typealias MainViewControllerAnimation = MainViewController
extension MainViewControllerAnimation {
    func animate() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
    }
}
