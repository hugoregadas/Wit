//
//  SearchScreenViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import UIKit

//MARK: - ViewModel Properties and methods
class SearchScreenViewModel {
    //MARK: - Properties
    // Service API
    private let serviceAPI = ServiceManager.shared
    
    // use to save id and image
    private var listOfImageData = [Int: Data]()
    
    /// Used to save all github Users
    var usersList =  [UsersObject]()
    
    var selectedItem: UsersObject?
    var loginName = ""
    var imageUser = UIImage()
    let viewTitle = "User List"
}

// MARK: - Extension: Supporting Methods
extension SearchScreenViewModel {
    /// Configure  data to show in tableView
    func configInfoTableViewTo(indexPath: IndexPath){
        let obj = usersList[indexPath.row]
        loginName = obj.login
        guard let data = listOfImageData[obj.idObject] else {
            return
        }
        
        imageUser = UIImage(data: data)!
    }
    /// method to select Item
    func selectedItem(withIndexPath index: IndexPath){
        selectedItem = usersList[index.row]
    }
}

// MARK: - Extension: Service Methods
extension SearchScreenViewModel {
    // method to fetch gitHub users
    func fetchGithubUsers(completion : @escaping (Result<Void,Error>) -> Void){
        serviceAPI.getUserListFromService { (results) in
            switch results {
            case .failure(let error):
                completion(.failure(error))
                break
            case .success(let listOfUsers):
                self.usersList = listOfUsers
                self.configureViewAndGetImages(userList: self.usersList) {
                    completion(.success(()))
                }
                break
            }
        }
    }
    
    // method to fetch images gitHub users
    private func configureViewAndGetImages(userList: [UsersObject] ,completion: @escaping () -> Void){
        /// Dispatch group used to sync all Service APi and to notify the getUserListFromService method that he can complete his task
        let serviceGroup = DispatchGroup()
        
        for user in self.usersList {
            if let url = user.avatarUrl {
                serviceGroup.enter()
                self.serviceAPI.getImageUserInfoWith(url: URL(string: url)!, idFile: "\(user.idObject)") { result in
                    switch result {
                    case .failure(_):
                        serviceGroup.leave()
                        break
                    case .success(let imageData):
                        self.listOfImageData.updateValue(imageData, forKey: user.idObject)
                        serviceGroup.leave()
                        break
                    }
                }
            }
        }
        
        serviceGroup.notify(queue: .main) {
            completion()
        }
    }
}

