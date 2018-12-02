//
//  ReceivedListTableViewCell.swift
//  finalprojecttrail
//
//  Created by Ruoyu Li on 11/28/18.
//  Copyright © 2018 Ruoyu Li. All rights reserved.
//

import UIKit

class ReceivedListTableViewCell: UITableViewCell {

    @IBOutlet weak var StartDate: UILabel!
    
    @IBOutlet weak var EndDate: UILabel!
    @IBOutlet weak var TypeLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
