//
//  MainVC.swift
//  Bantu
//
//  Created by Steven Muliamin on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    var isFirst: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isFirst {
            GlobalSession.setupUser {
                self.setupViews()
            }
            isFirst = true
        } else {
            setupViews()
        }
    }
    
    func setupViews() {
        let tabBarController: UITabBarController
        
        if let user = GlobalSession.currentUser {
            if user.role == .publicUser {
                tabBarController = getUserView()
            } else {
                tabBarController = getAdminView()
            }
        } else {
            tabBarController = getUserView()
        }
    
        self.present(tabBarController, animated: false)
    }
    
    private func getAdminView() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .bantuBlue
        
        let eventListVC = EventListViewController()
        eventListVC.title = "Events"
        eventListVC.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "calendar"), tag: 0)
        let eventNav = UINavigationController(rootViewController: eventListVC)
        eventNav.setBantuStyle()
        
        let adminSubmissionVC = AdminSubmissionListViewController(action: .acceptReject)
        adminSubmissionVC.title = "Submissions"
        adminSubmissionVC.tabBarItem = UITabBarItem(title: "Submissions", image: UIImage(named: "submit"), tag: 1)
        let adminSubmissionNav = UINavigationController(rootViewController: adminSubmissionVC)
        adminSubmissionNav.setBantuStyle()
        
        let controllers = [eventNav, adminSubmissionNav]
        tabBarController.viewControllers = controllers
        
        return tabBarController
    }
    
    private func getUserView() -> UITabBarController {
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
        
        let draftListVC = DraftListViewController()
        draftListVC.title = "Drafts"
        draftListVC.tabBarItem = UITabBarItem(title: "Drafts", image: UIImage(named: "drafts"), tag: 2)
        let draftNav = UINavigationController(rootViewController: draftListVC)
        draftNav.setBantuStyle()
        
        let controllers = [eventNav, defaultCreateDraftVC, draftNav]
        tabBarController.viewControllers = controllers
        
        return tabBarController
    }
    
}
