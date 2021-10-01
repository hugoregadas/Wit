//
//  UserDetailsViewController.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import UIKit

class UserDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Life cycle ViewController
    let viewModel = UserDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
}

// MARK: - Extension: Supporting Methods
extension UserDetailsViewController {
    func initUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailsTableViewCell")
        viewModel.delegate = self
        viewModel.getUserInfo()
        title = viewModel.viewTitle
    }
}

// MARK: - Extension: TableView Delegate and Data Source
extension UserDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell", for: indexPath) as! UserDetailsTableViewCell
        
        let firstObject = viewModel.arrayInfo[indexPath.row] as! Array<String>
        
        cell.titleLabel.text = firstObject[0]
        cell.detailLabel.text = firstObject[1]
        
        return cell
    }
}

// MARK: - Extension: Delegate ViewModel
extension UserDetailsViewController: UserDetailsViewModelDelegate {
    func updateViewController() {
        self.imageView.image = viewModel.userInfoImage
        tableView.reloadData()
    }
}

