//
//  AppDelegate.swift
//  Bantu
//
//  Created by Steven Muliamin on 25/06/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private func getTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .bantuBlue
        
        let eventListVC = EventListViewController()
        eventListVC.title = "Events"
        eventListVC.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "calendar"), tag: 0)
        let eventNav = UINavigationController(rootViewController: eventListVC)
        eventNav.setBantuStyle()

        let defaultCreateDraftVC = DefaultCreateDraftVC()
        defaultCreateDraftVC.title = ""
        defaultCreateDraftVC.tabBarItem = UITabBarItem(title: "Buat Draft", image: UIImage(named: "addDraft"), tag: 1)
//        defaultCreateDraftVC.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        let draftListVC = DraftListViewController()
        draftListVC.title = "Drafts"
        draftListVC.tabBarItem = UITabBarItem(title: "Drafts", image: UIImage(named: "drafts"), tag: 2)
        let draftNav = UINavigationController(rootViewController: draftListVC)
        draftNav.setBantuStyle()
        
        let controllers = [eventNav, defaultCreateDraftVC, draftNav]
        tabBarController.viewControllers = controllers
        
        return tabBarController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        window = UIWindow()
        window?.rootViewController = getTabBarController()
        window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

