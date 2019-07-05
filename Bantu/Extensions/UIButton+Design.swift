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
        self.backgroundColor = UIColor.init(red: 45/255, green: 122/255, blue: 143/255, alpha: 1)
        self.layer.cornerRadius = 15 //self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func buttonSecondDesign(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 45/255, green: 122/255, blue: 143/255, alpha: 1).cgColor
        self.layer.cornerRadius = 15 //self.frame.height / 2
        self.setTitleColor(UIColor.init(red: 45/255, green: 122/255, blue: 143/255, alpha: 1), for: .normal)
    }
    
    func buttonDesignDisabled(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setTitleColor(UIColor.lightGray, for: .normal)
    }
}
