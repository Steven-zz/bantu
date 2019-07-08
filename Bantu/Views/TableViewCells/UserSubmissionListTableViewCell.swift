//
//  UserSubmissionListTableViewCell.swift
//  Bantu
//
//  Created by Cason Kang on 07/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class UserSubmissionListTableViewCell: UITableViewCell {

    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(post: Post) {
        schoolImageView.downloaded(from: post.schoolImages.first!)
        schoolNameLbl.text = post.schoolName
        locationLbl.text = "\(post.location.locality), \(post.location.adminArea)"
        statusLbl.text = post.status.rawValue
        switch post.status {
        case .accepted:
            statusLbl.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .pending:
            statusLbl.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case .rejected:
            statusLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
}
