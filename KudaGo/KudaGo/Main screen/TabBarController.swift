//
//  TapBarController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let events = generateNavController(viewController: EventsViewController(),
                                           title: "События",
                                           image: UIImage(named: "event"))
        let bookmarks = generateNavController(viewController: BookmarkViewController(),
                                              title: "Избранное",
                                              image: UIImage(named: "bookmark_empty"))
        let settings = generateNavController(viewController: SettingsViewController(),
                                             title: "Настройки",
                                             image: UIImage(named: "settings"))

        viewControllers = [events, bookmarks, settings]

    }

    fileprivate func generateNavController(viewController: UIViewController,
                                           title: String,
                                           image: UIImage?) -> UINavigationController {
        viewController.navigationItem.title = title
        let navController = UINavigationController(rootViewController: viewController)
        navController.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
