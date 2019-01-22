//
//  ViewControllerTableViewCell.swift
//  makeapp
//
//  Created by Yulia on 22.01.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
