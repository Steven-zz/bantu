//
//  EventListViewController.swift
//  Bantu
//
//  Created by Cason Kang on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventListTable: UITableView!
    
//    var events: [Event]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTable.delegate = self
        eventListTable.dataSource = self
        
        eventListTable.register(UINib(nibName: "EventListTableViewCell", bundle: .main), forCellReuseIdentifier: "EventListCell")
        eventListTable.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventListTable.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListTableViewCell
        return cell
    }

}
