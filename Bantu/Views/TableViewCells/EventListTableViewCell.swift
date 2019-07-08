//
//  EventListTableViewCell.swift
//  Bantu
//
//  Created by Cason Kang on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventImageView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setContent(event: Event) {
        eventImageView.downloaded(from: event.imgUrl)
        eventNameLbl.text = event.eventName
        eventDateLbl.text = "\(event.startDate) - \(event.endDate)"
        eventLocationLbl.text = "\(event.post.location.locality), \(event.post.location.adminArea)"
    }
    
}
