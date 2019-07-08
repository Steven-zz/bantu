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
    var drafts: [DraftEntityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drafts = LocalServices.fetchAllDrafts()
        GlobalSession.selectedIndex = 2
    }
    
    func setupTableViews() {
        draftListTableView.dataSource = self
        draftListTableView.delegate = self
        
        draftListTableView.register(UINib(nibName: "DraftListTableViewCell", bundle: .main), forCellReuseIdentifier: "DraftCell")
        draftListTableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drafts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = draftListTableView.dequeueReusableCell(withIdentifier: "DraftCell", for: indexPath) as! DraftListTableViewCell
        cell.setContent(entity: drafts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreateDraftViewController(entityModel: drafts[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
