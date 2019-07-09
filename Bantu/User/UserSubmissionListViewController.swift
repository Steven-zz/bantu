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
    @IBOutlet weak var emptyView: UIView!
    
    private let refreshControl = UIRefreshControl()
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submissionListTableView.dataSource = self
        submissionListTableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .bantuBlue
        submissionListTableView.alwaysBounceVertical = true
        submissionListTableView.refreshControl = refreshControl
        
        submissionListTableView.register(UINib(nibName: "UserSubmissionListTableViewCell", bundle: .main), forCellReuseIdentifier: "UserSubmissionCell")
        submissionListTableView.tableFooterView = UIView()
        
        reloadSubmissions()
    }
    
    @objc func didPullToRefresh(_: Any) {
        reloadSubmissions()
    }
    
    func reloadSubmissions() {
        refreshControl.beginRefreshing()
        PostServices.getPosts(withUserID: GlobalSession.currentUser?.userID) { posts in
            self.posts = posts.reversed()
            DispatchQueue.main.sync {
                self.refreshControl.endRefreshing()
                self.emptyView.isHidden = !posts.isEmpty
                self.submissionListTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = submissionListTableView.dequeueReusableCell(withIdentifier: "UserSubmissionCell", for: indexPath) as! UserSubmissionListTableViewCell
        cell.setUI(post: posts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubmissionDetailViewController(userRole: .publicUser, post: posts[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

}
