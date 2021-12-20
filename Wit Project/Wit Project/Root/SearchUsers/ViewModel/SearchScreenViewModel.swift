//
//  SearchScreenViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import UIKit

//MARK: - ViewModel Properties and methods
class SearchScreenViewModel {
    //MARK: -  Private var
    private let serviceAPI: ServiceManager
    private var listOfImageData = [Int: Data]()
    private var usersList =  [UsersObject]()
    private var userListFilter = [InfoUserObject]()
    private var selectedItem: UsersObject?
    private var selectedItemFilter: InfoUserObject?
    private var loginName = ""
    private var imageUser = UIImage()
    
    //MARK: -  Public var
    var isFilter = false
    var titleView = "User List"
    var searchBarPlaceholder = "Search"
    var titleAlert = "Alerta"
    var buttonAlert = "OK"
    
    //MARK: - Initizaliers by ID
    init (serviceAPI: ServiceManager){
        self.serviceAPI = serviceAPI
    }
}

// MARK: - Extension: Supporting Methods
extension SearchScreenViewModel {
    
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
}

//MARK: - Data Source
extension SearchScreenViewModel {
    func numberOfRows() -> Int {
        if isFilter {
            return userListFilter.count
        }else {
            return usersList.count
        }
    }
}

// MARK: - Extension: Configure UserCellViewModel
extension SearchScreenViewModel {
    func configureUserCellViewModel(at index: Int) -> FactoryUserCellProtocol{
        if isFilter {
            return UserFilterCellViewModel(self.userListFilter[index], imageList: listOfImageData)
        }else {
            return UserCellViewModel(usersList[index], imageList: listOfImageData)
        }
    }
}

// MARK: - Extension: Configure UserDetailsViewModel
extension SearchScreenViewModel {
    func configureUserDetailsViewModel() -> UserDetailsViewModel{
        if isFilter {
            return UserDetailsViewModel(userName: selectedItemFilter!.login, idObject: selectedItemFilter!.idObject, serviceApi: serviceAPI)
        }else {
            return UserDetailsViewModel(userName: selectedItem!.login, idObject: selectedItem!.idObject, serviceApi: serviceAPI)
        }
    }
}


