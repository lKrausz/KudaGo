//
//  SceneDelegate.swift
//  KudaGo
//
//  Created by Виктория Козырева on 21.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        if DataManager.shared.getIsNewUserStatus() {
            let viewController = SettingViewController(type: .location, isOnboarding: true)
            let navController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navController
        } else {
            window?.rootViewController = TabBarController()
        }
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}
