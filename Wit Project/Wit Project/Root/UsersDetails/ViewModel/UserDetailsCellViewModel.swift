//
//  UserDetailsCellViewModel.swift
//  Wit Project
//
//  Created by Hugo Regadas on 20/12/2021.
//

import UIKit

class UserDetailsCellViewModel {
    //MARK: Private Var
    private var arrayInfo: [[String]]
    private var index: Int
    
    //MARK: - Public var
    var title: String {return self.arrayInfo[index][0]}
    var details: String{ return self.arrayInfo[index][1]}
    
    //MARK: - Initializer by ID
    init(arrayInfo: [[String]] = [], index: Int = 0){
        self.arrayInfo = arrayInfo
        self.index = index
    }
}
