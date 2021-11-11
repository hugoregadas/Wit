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
    private var listOfImageData = [Int: Data]() {
        didSet {
            if (!listOfImageData.isEmpty) {
                self.bindViewModelToController()
            }
        }
    }
    
    /// Used to save all github Users
    private (set) var usersList =  [UsersObject]()
    private (set) var userListFilter = [InfoUserObject]()
    private (set) var selectedItem: UsersObject?
    private (set) var selectedItemFilter: InfoUserObject?
    private (set) var loginName = ""
    private (set) var imageUser = UIImage()
    private (set) var isFilter = false
    

    var bindViewModelToController : (() -> ()) = {}
}

// MARK: - Extension: Supporting Methods
extension SearchScreenViewModel {
    /// Configure  data to show in tableView
    func configInfoTableViewTo(indexPath: IndexPath){
        var objId: Int
        if isFilter {
            let obj = userListFilter[indexPath.row]
            objId = obj.idObject
            loginName = obj.login
        }else{
            let obj = usersList[indexPath.row]
            objId = obj.idObject
            loginName = obj.login
        }
        
        
        guard let data = listOfImageData[objId] else {
            imageUser = UIImage(named: "1024")!
            return
        }
        
        imageUser = UIImage(data: data)!
    }
    
    /// method to select Item
    func selectedItem(withIndexPath index: IndexPath){
        selectedItem = nil
        selectedItemFilter = nil
        
        if isFilter {
            selectedItemFilter = userListFilter[index.row]
        }else{
            selectedItem = usersList[index.row]
        }
    }
}

// MARK: - Extension: Service Methods
extension SearchScreenViewModel {
    // method to fetch gitHub users
    func fetchGithubUsers(completion : @escaping (Result<Void,Error>) -> Void){
        let lastID = usersList.last?.idObject
        serviceAPI.getUserListFromService(since: lastID ?? 0) { (results) in
            switch results {
            case .failure(let error):
                completion(.failure(error))
                break
            case .success(let listOfUsers):
                self.usersList.append(contentsOf: listOfUsers)
                self.isFilter = false
                var arrayWithAvatarURLAndUserID = [(String, Int)]()
                for user in self.usersList {
                    arrayWithAvatarURLAndUserID.append((user.avatarUrl!, user.idObject))
                }
                
                self.configureViewAndGetImages(withArray: arrayWithAvatarURLAndUserID)
                completion(.success(()))
                break
            }
        }
    }
    
    //Method to fetch user
    func getUser(WithName username: String, completion: @escaping (Result<Void, Error>) -> Void){
        serviceAPI.getUserInfo(userName: username) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                break
            case .success(let userData):
                self.isFilter = true
                self.userListFilter = [userData]
                var arrayWithAvatarURLAndUserID = [(String, Int)]()
                for user in self.userListFilter {
                    arrayWithAvatarURLAndUserID.append((user.avatarUrl!, user.idObject))
                }
                
                self.configureViewAndGetImages(withArray: arrayWithAvatarURLAndUserID)
                completion(.success(()))

                break
            }
        }
    }
    
    // method to fetch images gitHub users
    private func configureViewAndGetImages(withArray imageInfo: [(urlAvatar: String ,userId: Int)]){
        /// Dispatch group used to sync all Service APi and to notify the getUserListFromService method that he can complete his task
        
        for user in imageInfo {
            self.serviceAPI.getImageUserInfoWith(url: URL(string: user.urlAvatar)!, idFile: "\(user.userId)") { result in
                switch result {
                case .failure(_):
                    break
                case .success(let imageData):
                    self.listOfImageData.updateValue(imageData, forKey: user.userId)
                    break
                }
            }
        }
    }
}

