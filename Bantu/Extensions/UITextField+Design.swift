//
//  UITextField+Image.swift
//  Bantu
//
//  Created by Cason Kang on 01/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextFieldExtension: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 45/255, green: 122/255, blue: 143/255, alpha: 1).cgColor
        self.layer.cornerRadius = 15
        
        if let image = leftImage {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 25, height: 25))
            imageView.image = image
            imageView.tintColor = tintColor
            
            var width = leftPadding + 23
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width = width + 7
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 25))
            view.addSubview(imageView)
            
            leftView = view
            
        } else {
            leftViewMode = .never
        }
        
    }
}

class CreateDraftFieldExtension: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
