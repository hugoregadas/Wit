//
//  UserDetailsViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 24/09/2021.
//

import UIKit

//MARK: - Protocol
protocol UserDetailsViewModelDelegate: NSObject {
    func updateViewController()
}

//MARK: - ViewModel Properties and methods
class UserDetailsViewModel {
    //MARK: - Properties
    weak var delegate: UserDetailsViewModelDelegate?
    let networker = ServiceManager.shared
    var username: String?
    var idObject: Int?
    var viewTitle = "User"
    var arrayInfo = [Any]()
    var userInfoImage: UIImage?
}

// MARK: - Extension: Supporting Methods
extension UserDetailsViewModel {
    func configureArrayWith(infoUser: InfoUserObject){
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
    func getUserInfo(){
        if let username = username, let idObject = idObject {
            networker.getUserInfo(userName: username, idObject: "\(idObject)") { infoUser in
                guard let urlImage = infoUser.avatarUrl else {
                    return
                }
                self.configureArrayWith(infoUser: infoUser)
                
                let group = DispatchGroup()
                group.enter()
                
                self.networker.getImageUserInfoWith(url: URL(string: urlImage)!, idFile: String(idObject)) { data in
                    self.userInfoImage = UIImage(data: data)
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    self.delegate?.updateViewController()
                }
            }
        }
    }
}
