//
//  UserDetailsViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 24/09/2021.
//

import UIKit

//MARK: - ViewModel Properties and methods
class UserDetailsViewModel {
    //MARK: - Properties
    private let serviceAPI = ServiceManager.shared
    var username: String?
    var idObject: Int?
    let viewTitle = "User"
    var arrayInfo = [[String]]()
    var userInfoImage: UIImage?
}

// MARK: - Extension: Supporting Methods
extension UserDetailsViewModel {
    private func configureArrayWith(infoUser: InfoUserObject){
        self.arrayInfo.append(["Name" , infoUser.login])
        
        if let company = infoUser.company {
            self.arrayInfo.append(["Company" , company])
        }
        
        if let blog = infoUser.blog {
            self.arrayInfo.append(["Blog" , blog])
        }
        
        if let location = infoUser.location {
            self.arrayInfo.append(["Location" , location])
        }
        
        if let email = infoUser.email {
            self.arrayInfo.append(["Email" , email])
        }
        
        if let hireable = infoUser.hireable {
            self.arrayInfo.append(["Hireable" , hireable])
        }
        
        if let bio = infoUser.bio {
            self.arrayInfo.append(["Bio" , bio])
        }
        
        if let twitter = infoUser.twitterUsername {
            self.arrayInfo.append(["Twitter Username" , twitter])
        }
        
        if let publicRepos = infoUser.publicRepos {
            self.arrayInfo.append(["Followers" , "\(publicRepos)"])
        }
        
        if let publicRepos = infoUser.publicRepos {
            self.arrayInfo.append(["Following" , "\(publicRepos)"])
        }
        
        if let publicGists = infoUser.publicGists {
            self.arrayInfo.append(["Followers" , "\(publicGists)"])
        }
        
        if let following = infoUser.following {
            self.arrayInfo.append(["Following" , "\(following)"])
        }
        
        if let createdAt = infoUser.createdAt {
            self.arrayInfo.append(["Created at" , "\(createdAt)"])
        }
        
        if let updatedAt = infoUser.updatedAt {
            self.arrayInfo.append(["Updated at" , "\(updatedAt)"])
        }
    }
}

// MARK: - Extension: Service Methods
extension UserDetailsViewModel {
    func getUserInfo(completion: @escaping (Result<Void, Error>) -> Void){
        if let username = username, let idObject = idObject {
            serviceAPI.getUserInfo(userName: username, idObject: "\(idObject)") { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    break
                case .success(let userData):
                    self.configureViewAndGetImages(userData, completion: {
                        completion(.success(()))
                    })
                    break
                }
            }
        }
    }
    
    private func configureViewAndGetImages(_ infoUser: InfoUserObject, completion: @escaping () -> Void ){
        guard let urlImage = infoUser.avatarUrl else {
            return
        }
        self.configureArrayWith(infoUser: infoUser)
        
        let group = DispatchGroup()
        group.enter()
        
        self.serviceAPI.getImageUserInfoWith(url: URL(string: urlImage)!, idFile: String(idObject!)) { result in
            switch result {
            case .failure(_):
                group.leave()
                break
            case .success(let data):
                self.userInfoImage = UIImage(data: data)
                group.leave()
                break
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
