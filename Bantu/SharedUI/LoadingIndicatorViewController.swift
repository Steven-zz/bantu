//
//  LoadingIndicatorViewController.swift
//  Bantu
//
//  Created by Cason Kang on 01/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class LoadingIndicatorViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.masksToBounds = true
        activityIndicator.color = UIColor.init(red: 165/255, green: 0/255, blue: 1/255, alpha: 1)
        activityLbl.textColor = UIColor.init(red: 165/255, green: 0/255, blue: 1/255, alpha: 1)
    }

    public func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    public func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    public func setLbl(activity: String) {
        activityLbl.text = activity
    }
    
    public func finish() {
        self.dismiss(animated: false, completion: nil)
    }
    
    class func getIndicatorView() -> LoadingIndicatorViewController {
        let viewController = LoadingIndicatorViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .coverVertical
        return viewController
    }
    
    static var indicatorVC: LoadingIndicatorViewController {
        let viewController = LoadingIndicatorViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .coverVertical
        return viewController
    }
}

