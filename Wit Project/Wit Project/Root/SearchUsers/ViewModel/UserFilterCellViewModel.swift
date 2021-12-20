//
//  UserFilterCellViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 20/12/2021.
//

import UIKit

class UserFilterCellViewModel: FactoryUserCellProtocol{

    // MARK: - Private Var
    private let user: InfoUserObject
    private var listOfImageData: [Int: Data]

    // MARK: - Public Var
    var title: String {
        get{
            return user.login
        }
    }
    
    var image: UIImage {
        get {
            guard let data = listOfImageData[self.user.idObject] else {
                return  UIImage(named: "1024")!
                
            }
            
            return UIImage(data: data)!
        }
    }

    
    // MARK: - Initializer by ID
    init(_ user: InfoUserObject, imageList: [Int: Data]){
        self.user = user
        self.listOfImageData = imageList
    }

}
