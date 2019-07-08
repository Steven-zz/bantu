//
//  SeeMoreViewController.swift
//  Bantu
//
//  Created by Cason Kang on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class SeeMoreViewController: UIViewController {

    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var priceIncludingField: UITextView!
    @IBOutlet weak var requirementsField: UITextView!
    @IBOutlet weak var additionalInfoField: UITextView!
    @IBOutlet weak var contactPersonField: UITextView!
    
    let event:Event
    
    init(event: Event) {
        self.event = event
        
        super.init(nibName: "SeeMoreViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutField.text = event.description
        priceIncludingField.text = event.feeInfo
        requirementsField.text = event.requirements
        additionalInfoField.text = event.eventNotes
        contactPersonField.text = event.eventContactNumber
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
