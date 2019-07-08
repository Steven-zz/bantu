//
//  DraftListTableViewCell.swift
//  Bantu
//
//  Created by Cason Kang on 04/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class DraftListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(entity: DraftEntityModel) {
        nameLbl.text = entity.schoolName
        dateLbl.text = entity.timeStamp
    }
    
}
