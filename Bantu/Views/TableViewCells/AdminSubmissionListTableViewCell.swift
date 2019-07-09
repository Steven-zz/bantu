//
//  AdminSubmissionListTableViewCell.swift
//  Bantu
//
//  Created by Cason Kang on 05/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit
import PINRemoteImage

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
        schoolImage.pin_updateWithProgress = true
        schoolImage.pin_setPlaceholder(with: UIImage(named: "broken-image"))
        schoolImage.pin_setImage(from: URL(string: post.schoolImages.first ?? ""))
        schoolNameLbl.text = post.schoolName
        schoolLocationLbl.text = "\(post.location.locality), \(post.location.adminArea)"
        userNameLbl.text = post.user.fullName
        dateLbl.text = post.timeStamp
    }
    
}
