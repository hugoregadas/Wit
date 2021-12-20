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
    
    //MARK: - Private Var
    private var viewModel: UserDetailsViewModel
    
    //MARK: - Initialize
    init?(viewModel: UserDetailsViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    //É necessário por causa do storyboard...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

// MARK: - Extension: Supporting Methods
extension UserDetailsViewController {
    private func initUI(){
        initTableView()
        fetchUser()
        title = viewModel.viewTitle
    }
    
    private func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailsTableViewCell")
    }
    
    private func fetchUser(){
        viewModel.getUserInfo { result in
            switch result {
            case .failure(let error):
                self.showError(error)
                break
            case .success(_):
                self.imageView.image = self.viewModel.userInfoImage
                self.tableView.reloadData()
                break
            }
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async {
            let title = "Alerta"
            let message = error.localizedDescription
            let buttonTitle = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Extension: TableView Delegate and Data Source
extension UserDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell", for: indexPath) as! UserDetailsTableViewCell
        cell.configureCell(viewModel: viewModel.configureViewModel(at: indexPath.row))
        return cell
    }
}
