//
//  UIButton+Design.swift
//  Bantu
//
//  Created by Cason Kang on 03/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func buttonDesign(){
        self.backgroundColor = .bantuBlue
        self.layer.cornerRadius = 15 //self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func buttonSecondDesign(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.bantuBlue.cgColor
        self.layer.cornerRadius = 15 //self.frame.height / 2
        self.setTitleColor(.bantuBlue, for: .normal)
    }
    
    func buttonDesignDisabled(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setTitleColor(UIColor.lightGray, for: .normal)
    }
}
