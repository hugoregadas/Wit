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
    let viewModel = SearchScreenViewModel()
    
    //MARK: - Life cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUI()
    }
}

// MARK: - Extension: Supporting Methods
extension SearchScreenViewController {
    func initUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "ListUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ListUserTableViewCell")
        viewModel.delegate = self
        viewModel.getDataService()
        title = viewModel.viewTitle
    }
}

// MARK: - Extension: SearchScreenViewModelDelegate
extension SearchScreenViewController : SearchScreenViewModelDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}

// MARK: - Extension: TableView Delegate and Data Source
extension SearchScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserTableViewCell", for: indexPath) as! ListUserTableViewCell
        viewModel.configInfoTableViewTo(indexPath: indexPath)
        cell.userNameLabel.text = viewModel.loginName
        cell.userImage.image = viewModel.imageUser
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
        vc.viewModel.username = viewModel.selectedItem?.login
        vc.viewModel.idObject = viewModel.selectedItem?.idObject
    }
}

