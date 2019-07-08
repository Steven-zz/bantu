//
//  DefaultCreateDraftVC.swift
//  Bantu
//
//  Created by Steven Muliamin on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class DefaultCreateDraftVC: UIViewController {
    
    var isAdd: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isAdd {
            let createDraftVC = CreateDraftViewController()
            let nav = UINavigationController(rootViewController: createDraftVC)
            nav.setBantuStyle()
            self.present(nav, animated: true)
            isAdd.toggle()
        } else {
            self.tabBarController?.selectedIndex = GlobalSession.selectedIndex
            isAdd.toggle()
        }
    }
}
