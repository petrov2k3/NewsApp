//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        //MARK: - ViewContollers
        let homeVC = HomeViewController() // start screen
        let categoriesVC = makeCategoriesViewController()
        
        //MARK: - Navigation
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(
            title: "Головна",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        let categoryNavController = UINavigationController(rootViewController: categoriesVC)
        categoryNavController.tabBarItem = UITabBarItem(
            title: "Категорії",
            image: UIImage(systemName: "list.bullet.clipboard"),
            selectedImage: UIImage(systemName: "list.bullet.clipboard.fill")
        )
        
        //MARK: - TabBar
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([homeNavController, categoryNavController], animated: true)
        
        tabBarVC.tabBar.backgroundColor = .systemBackground
        
        window.rootViewController = tabBarVC
        self.window = window
        window.makeKeyAndVisible()
    }

    private func makeCategoriesViewController() -> UIViewController {
        let presenter = CategoriesPresenterImpl()
        let viewController = CategoriesViewControllerImpl(presenter: presenter)
        
        presenter.setupView(viewController)
        
        return viewController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
