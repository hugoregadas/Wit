//
//  ListUserTableViewCell.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(viewModel: SearchScreenViewModel, indexPath: IndexPath) {
        viewModel.configInfoTableViewTo(indexPath: indexPath)
        userNameLabel.text = viewModel.loginName
        userImage.image = viewModel.imageUser
        
    }
    
}
