//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Artyom Ivanov on 02.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // di container
        let newsManager = DIContainer.shared.makeNewsManager()
        let newsRealmManager = DIContainer.shared.makeNewsNewsRealmManager()
        
        // view controllers
        let newsViewController = NewsViewController(newsManager: newsManager, newsRealmManager: newsRealmManager)
        let savedNewsViewController = SavedNewsViewController(newsRealmManager: newsRealmManager)
        
        // navigations controllers
        let newsNavigationController = UINavigationController(rootViewController: newsViewController)
        let savedNewsNavigationController = UINavigationController(rootViewController: savedNewsViewController)
        
        // tab-bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [newsNavigationController, savedNewsNavigationController]
        newsNavigationController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
        savedNewsNavigationController.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 1)
        
        tabBarController.tabBar.tintColor = .blue
        tabBarController.tabBar.unselectedItemTintColor = .white
        tabBarController.tabBar.barTintColor = .black
        tabBarController.tabBar.isTranslucent = false
        
        window.rootViewController = tabBarController
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}
