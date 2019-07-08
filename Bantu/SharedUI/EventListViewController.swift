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
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTable.delegate = self
        eventListTable.dataSource = self
        
        eventListTable.register(UINib(nibName: "EventListTableViewCell", bundle: .main), forCellReuseIdentifier: "EventListCell")
        eventListTable.tableFooterView = UIView()
        
        reloadEvents()
    }
    
    func reloadEvents() {
        EventServices.getEvents() { events in
            self.events = events
            DispatchQueue.main.sync {
                self.eventListTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalSession.selectedIndex = 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventListTable.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListTableViewCell
        cell.setContent(event: events[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRole: User.Role = GlobalSession.currentUser?.role ?? .publicUser
        let vc = EventDetailViewController(userRole: userRole, event: events[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
