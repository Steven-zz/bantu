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
    public func setContent(post: Post) {
        self.schoolImage.downloaded(from: post.schoolImages.first!)
        self.schoolNameLbl.text = post.schoolName
        self.schoolLocationLbl.text = "\(post.location.locality), \(post.location.adminArea)"
        self.userNameLbl.text = post.user.fullName
        self.dateLbl.text = post.timeStamp
    }
    
}
