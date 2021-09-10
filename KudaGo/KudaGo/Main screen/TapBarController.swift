//
//  TapBarController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit

class TapBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let events = generateNavController(vc: EventsViewController(), title: "Events", image: UIImage(named: "event"))
        let bookmarks = generateNavController(vc: BookMarksViewController(), title: "Bookmarks", image: UIImage(named: "bookmark"))
        let settings = generateNavController(vc: SettingsViewController(), title: "Settings", image: UIImage(named: "settings"))
        
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [events, bookmarks, settings]

    }
    
    fileprivate func generateNavController(vc: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
}
