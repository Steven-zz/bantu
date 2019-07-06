//
//  AdminSubmissionListViewController.swift
//  Bantu
//
//  Created by Cason Kang on 05/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class AdminSubmissionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var SubmissionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableViews()
    }

    func setupTableViews() {
        SubmissionTable.dataSource = self
        SubmissionTable.delegate = self
        
        SubmissionTable.register(UINib(nibName: "AdminSubmissionListTableViewCell", bundle: .main), forCellReuseIdentifier: "AdminSubmissionCell")
        SubmissionTable.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SubmissionTable.dequeueReusableCell(withIdentifier: "AdminSubmissionCell", for: indexPath) as! AdminSubmissionListTableViewCell
        cell.setContent(imageLink: "", schoolName: "Jubilee", schoolLocation: "Sunter, Kemayoran", userName: "Cason Kang", date: "20/10/2019")
        
        return cell
    }
    
    
}
