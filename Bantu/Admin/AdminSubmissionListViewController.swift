//
//  AdminSubmissionListViewController.swift
//  Bantu
//
//  Created by Cason Kang on 05/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

protocol AdminSubmissionListDelegate {
    func didSelectPost(post: Post)
}

class AdminSubmissionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var SubmissionTable: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    let action: Action
    var delegate: AdminSubmissionListDelegate?
    
    var posts: [Post] = []
    
    enum Action { // klo choose pake delegate klo acceptreject buka detail
        case choosePost
        case acceptReject
    }
    
    init(action: Action) {
        self.action = action
        super.init(nibName: "AdminSubmissionListViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .bantuBlue
        SubmissionTable.alwaysBounceVertical = true
        SubmissionTable.refreshControl = refreshControl
        
        if action == .acceptReject {
            getPendingPosts()
        } else {
            getAcceptedPosts()
        }
    }
    
    @objc func didPullToRefresh(_: Any) {
        if action == .acceptReject {
            getPendingPosts()
        } else {
            getAcceptedPosts()
        }
    }
    
    func getAcceptedPosts() {
        refreshControl.beginRefreshing()
        PostServices.getPosts(withStatus: .accepted) { posts in
            self.posts = posts.reversed()
            DispatchQueue.main.sync {
                self.refreshControl.endRefreshing()
                self.emptyView.isHidden = !posts.isEmpty
                self.SubmissionTable.reloadData()
            }
        }
    }
    
    func getPendingPosts() {
        refreshControl.beginRefreshing()
        PostServices.getPosts(withStatus: .pending) { posts in
            self.posts = posts.reversed()
            DispatchQueue.main.sync {
                self.refreshControl.endRefreshing()
                self.emptyView.isHidden = !posts.isEmpty
                self.SubmissionTable.reloadData()
            }
        }
    }

    func setupTableViews() {
        SubmissionTable.dataSource = self
        SubmissionTable.delegate = self
        
        SubmissionTable.register(UINib(nibName: "AdminSubmissionListTableViewCell", bundle: .main), forCellReuseIdentifier: "AdminSubmissionCell")
        SubmissionTable.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SubmissionTable.dequeueReusableCell(withIdentifier: "AdminSubmissionCell", for: indexPath) as! AdminSubmissionListTableViewCell
        cell.setContent(post: posts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if action == .choosePost {
            self.delegate?.didSelectPost(post: posts[indexPath.row])
            navigationController?.popViewController(animated: true)
        } else {
            let vc = SubmissionDetailViewController(userRole: .admin, post: posts[indexPath.row])
            vc.adminListVC = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
