//
//  UserSubmissionListViewController.swift
//  Bantu
//
//  Created by Cason Kang on 07/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

class UserSubmissionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var submissionListTableView: UITableView!
    
    let posts: [Post] = [Post(statusID: 1, schoolName: "Binus1", schoolImages: ["https://i.dailymail.co.uk/i/pix/2015/09/01/18/2BE1E88B00000578-3218613-image-m-5_1441127035222.jpg"], location: Location(locality: "Tangerang", adminArea: "Banten")),Post(statusID: 2, schoolName: "Binus2", schoolImages: ["https://i.dailymail.co.uk/i/pix/2015/09/01/18/2BE1E88B00000578-3218613-image-m-5_1441127035222.jpg"], location: Location(locality: "Tangerang", adminArea: "Bantenn")),Post(statusID: 3, schoolName: "Binus3", schoolImages: ["https://i.dailymail.co.uk/i/pix/2015/09/01/18/2BE1E88B00000578-3218613-image-m-5_1441127035222.jpg"], location: Location(locality: "Tangerang", adminArea: "Bantennn"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submissionListTableView.dataSource = self
        submissionListTableView.delegate = self
        
        submissionListTableView.register(UINib(nibName: "UserSubmissionListTableViewCell", bundle: .main), forCellReuseIdentifier: "UserSubmissionCell")
        submissionListTableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = submissionListTableView.dequeueReusableCell(withIdentifier: "UserSubmissionCell", for: indexPath) as! UserSubmissionListTableViewCell
        let post = posts[indexPath.row]
        cell.setUI(post: posts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubmissionDetailViewController(userRole: .publicUser, post: posts[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

}
