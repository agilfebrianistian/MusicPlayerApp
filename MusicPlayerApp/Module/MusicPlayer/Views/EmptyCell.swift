//
//  EmptyCell.swift
//  AgilBoilerplate
//
//  Created by Agil Febrianistian on 13/10/23.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    @IBOutlet weak var warningMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
