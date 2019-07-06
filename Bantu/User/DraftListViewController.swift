//
//  DraftListViewController.swift
//  Bantu
//
//  Created by Cason Kang on 04/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class DraftListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var draftListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableViews()
        // Do any additional setup after loading the view.
    }
    
    func setupTableViews() {
        draftListTableView.dataSource = self
        draftListTableView.delegate = self
        
        draftListTableView.register(UINib(nibName: "DraftListTableViewCell", bundle: .main), forCellReuseIdentifier: "DraftCell")
        draftListTableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = draftListTableView.dequeueReusableCell(withIdentifier: "DraftCell", for: indexPath) as! DraftListTableViewCell
        
        cell.setContent(name: "AAAAA", date: "AAA")
        
        return cell
    }

}
