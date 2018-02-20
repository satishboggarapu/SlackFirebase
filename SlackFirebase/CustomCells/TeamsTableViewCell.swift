//
//  TeamsTableViewCell.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/19/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class TeamsTableViewCell: UITableViewCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamUrlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
