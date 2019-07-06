//
//  AdminSubmissionListTableViewCell.swift
//  Bantu
//
//  Created by Cason Kang on 05/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class AdminSubmissionListTableViewCell: UITableViewCell {

    @IBOutlet weak var schoolImage: UIImageView!
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var schoolLocationLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func setContent(imageLink: String, schoolName: String, schoolLocation:String , userName: String, date: String) {
        self.schoolImage.downloaded(from: imageLink)
        self.schoolNameLbl.text = schoolName
        self.schoolLocationLbl.text = schoolLocation
        self.userNameLbl.text = userName
        self.dateLbl.text = date
    }
    
}
