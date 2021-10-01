//
//  SearchScreenViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import UIKit

//MARK: - Protocol
protocol SearchScreenViewModelDelegate: NSObject {
    func updateTableView()
}

//MARK: - ViewModel Properties and methods
class SearchScreenViewModel {
    //MARK: - Properties
    let networker = ServiceManager.shared
    var items =  [UsersObject]()
    var selectedItem: UsersObject?
    weak var delegate: SearchScreenViewModelDelegate?
    var loginName: String?
    var imageUser : UIImage?
    var viewTitle = "User List"
    var itensAndImages = [Int: Data]()
}

// MARK: - Extension: Supporting Methods
extension SearchScreenViewModel {
    func configInfoTableViewTo(indexPath: IndexPath){
        let obj = items[indexPath.row]
        loginName = obj.login
        guard let data = itensAndImages[obj.idObject] else {
            return
        }
        
        imageUser = UIImage(data: data)
    }
    
    func selectedItem(withIndexPath index: IndexPath){
        selectedItem = items[index.row]
    }
}

// MARK: - Extension: Service Methods
extension SearchScreenViewModel {
    func getDataService(){
        networker.getUserListFromService{ objList in
            self.items = objList
            
            let group = DispatchGroup()
            for item in self.items {
                if let url = item.avatarUrl {
                    group.enter()
                    self.networker.getImageUserInfoWith(url: URL(string: url)!, idFile: "\(item.idObject)") { data in
                        self.itensAndImages.updateValue(data, forKey: item.idObject)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.delegate?.updateTableView()
            }
        }
    }
}

