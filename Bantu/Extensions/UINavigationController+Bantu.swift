//
//  UINavigationController+Bantu.swift
//  Bantu
//
//  Created by Steven Muliamin on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func setBantuStyle() {
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationBar.barTintColor = .bantuBlue
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .white
    }
}
