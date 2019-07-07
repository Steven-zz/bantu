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
    
    @IBOutlet weak var SubmissionTable: UITableView!
    
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
        
        PostServices.getPosts() { posts in
            self.posts = posts
            DispatchQueue.main.sync {
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
        let post = posts[indexPath.row]
        let locationString = post.location.locality + ", " + post.location.adminArea
        cell.setContent(imageLink: post.schoolImages.first ?? "", schoolName: post.schoolName, schoolLocation: locationString, userName: post.user.fullName, date: post.timeStamp)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if action == .choosePost {
            self.delegate?.didSelectPost(post: posts[indexPath.row])
            navigationController?.popViewController(animated: true)
        } else {
            let vc = SubmissionDetailViewController(userType: .admin, post: posts[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
