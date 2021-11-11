//
//  SearchScreenViewController.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//


/// Roles View controller
///
///  1 - IBOutlets
///  2 - Properties
///  3 - Life cycle ViewController
///  4 - UI
///  5 - Delegates
///  6 - Actions
///  7 - Segue

import UIKit

class SearchScreenViewController: UIViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loading: UIActivityIndicatorView! {
        didSet {
            loading.hidesWhenStopped = true
        }
    }
    
    //Properties
    private let viewModel = SearchScreenViewModel()
}

//MARK: - Life cycle ViewController
extension SearchScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

// MARK: - Extension: Init User Interface (UI)
extension SearchScreenViewController {
    func initUI(){
        initTableView()
        initSearchBar()
        fetchUsersGitHub()
        title = "User List"
        
        self.viewModel.bindViewModelToController = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "ListUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ListUserTableViewCell")
    }
    
    func initSearchBar(){
        searchBar.placeholder = "Search"
        searchBar.delegate = self
    }
}

// MARK: - Extension: TableView Delegate and Data Source
extension SearchScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewModel.isFilter){
            return viewModel.userListFilter.count
        }else{
            return viewModel.usersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserTableViewCell", for: indexPath) as! ListUserTableViewCell
        cell.configureCell(viewModel: viewModel, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedItem(withIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
        searchBar.endEditing(true)
        performSegue(withIdentifier: "SegueDetails", sender: self)
    }
}

//MARK: - Extension: SearchBar Delegate
extension SearchScreenViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if (searchBar.text?.count != 0){
            viewModel.getUser(WithName: searchBar.text!) { result in
                switch result {
                case.failure(let error):
                    self.showError(error)
                    break
                case.success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    break
                }
            }
        }else {
            fetchUsersGitHub()
        }
    }
}

// MARK: - Extension: Actions
extension SearchScreenViewController {
    ///  Button to fetch more users
    @IBAction func moreUsers(_ sender: UIBarButtonItem) {
        fetchUsersGitHub()
    }
    
    func fetchUsersGitHub(){
        loading.startAnimating()
        viewModel.fetchGithubUsers(completion: { result in
            DispatchQueue.main.async {
                self.loading.stopAnimating()
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
            }
        })
    }
    
    /// When fetch fail action o show error
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

// MARK: - Extension: Segue
extension SearchScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UserDetailsViewController
        
        if let selectedItem = viewModel.selectedItem {
            vc.viewModel.username = selectedItem.login
            vc.viewModel.idObject = selectedItem.idObject
        }else if let selectedItemFilter = viewModel.selectedItemFilter{
            vc.viewModel.username = selectedItemFilter.login
            vc.viewModel.idObject = selectedItemFilter.idObject
        }
    }
}

