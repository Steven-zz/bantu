//
//  EventListViewController.swift
//  Bantu
//
//  Created by Cason Kang on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var eventListTable: UITableView!
    
    var events: [Event] = []
    var filteredEvents: [Event] = []
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        eventListTable.delegate = self
        eventListTable.dataSource = self
        
        eventListTable.register(UINib(nibName: "EventListTableViewCell", bundle: .main), forCellReuseIdentifier: "EventListCell")
        eventListTable.tableFooterView = UIView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profileIcon"), style: .plain, target: self, action: #selector(toProfile(_:)))
        if GlobalSession.currentUser?.role == .admin {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        }
        
        reloadEvents()
    }
    
    func reloadEvents() {
        EventServices.getEvents() { events in
            self.events = events
            DispatchQueue.main.sync {
                self.emptyView.isHidden = !events.isEmpty
                self.eventListTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalSession.selectedIndex = 0
        
        if GlobalSession.didChangeUser {
            if let user = GlobalSession.currentUser,
                user.role == .publicUser {
                return
            }
            self.dismiss(animated: false)
            GlobalSession.didChangeUser = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == true {
            return filteredEvents.count
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventListTable.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListTableViewCell
        if searching == true {
            cell.setContent(event: filteredEvents[indexPath.row])
        } else {
            cell.setContent(event: events[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRole: User.Role = GlobalSession.currentUser?.role ?? .publicUser
        if searching == true {
            let vc = EventDetailViewController(userRole: userRole, event: filteredEvents[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = EventDetailViewController(userRole: userRole, event: events[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func add(_ button: UIBarButtonItem) {
        let vc = CreateEventViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.setBantuStyle()
        navigationController?.present(nav, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func toProfile(_ button: UIBarButtonItem) {
        let vc: UIViewController
        if let _ = GlobalSession.currentUser {
            vc = ProfileViewController()
        } else {
            vc = LogInViewController()
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.setBantuStyle()
        navigationController?.present(nav, animated: true)
    }
}

extension EventListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredEvents = self.events.filter({$0.eventName.lowercased().contains(searchText.lowercased())})
        if searchText == ""{
            self.filteredEvents = self.events
        }
        searching = true
        self.eventListTable.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.eventListTable.reloadData()
        self.becomeFirstResponder()
    }
}
