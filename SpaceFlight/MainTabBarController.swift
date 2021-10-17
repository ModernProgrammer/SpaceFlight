//
//  MainTabBarController.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/16/21.
//

import UIKit

class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        setupMenuBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name(rawValue: "tabbar"), object: nil)

    }
    
    fileprivate func setupMenuBar() {
        tabBar.tintColor = UIColor.systemRed
    }
    
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let isHidden = notification.userInfo?["isHidden"] as? Bool else { return }
        self.setTabBar(hidden: isHidden)
    }
    
    fileprivate func setUpControllers() {
        let home = SpaceFlightViewController()
        let resources = ResourcesViewController(style: .insetGrouped)
        let homeViewController = templateNavController(unselectedImage: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"),rootViewController: home)
        let resourcesViewController = templateNavController(unselectedImage: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"), rootViewController: resources)
        viewControllers = [homeViewController, resourcesViewController]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let viewNavController = UINavigationController(rootViewController: viewController)
        viewNavController.tabBarItem.image = unselectedImage
        viewNavController.tabBarItem.selectedImage = selectedImage
        return viewNavController
    }
}
