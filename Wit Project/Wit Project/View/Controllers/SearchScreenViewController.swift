//
//  SearchScreenViewController.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import UIKit

class SearchScreenViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let viewModel = SearchScreenViewModel()
    
    //MARK: - Life cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

// MARK: - Extension: Supporting Methods
extension SearchScreenViewController {
    func initUI(){
        initTableView()
        fetchUsersGitHub()
        title = viewModel.viewTitle
    }
    
    func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "ListUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ListUserTableViewCell")
    }
    
    func fetchUsersGitHub(){
        viewModel.fetchGithubUsers(completion: { result in
            
            switch result {
            case .failure(let error):
                self.showError(error)
                break
            case .success():
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            }
        })
    }
    
    func showError(_ error: Error) {
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
extension SearchScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserTableViewCell", for: indexPath) as! ListUserTableViewCell
        cell.configureCell(viewModel: viewModel, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedItem(withIndexPath: indexPath)
        performSegue(withIdentifier: "SegueDetails", sender: self)
    }
}

// MARK: - Extension: Segue
extension SearchScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UserDetailsViewController
        
        if let selectedItem = viewModel.selectedItem {
            vc.viewModel.username = selectedItem.login
            vc.viewModel.idObject = selectedItem.idObject
        }
    }
}

