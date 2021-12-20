//
//  UserDetailsTableViewCell.swift
//  Wit Project
//
//  Created by Hugo Regadas on 24/09/2021.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Public Methods
    func configureCell(viewModel: UserDetailsCellViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.details
    }
    
}
