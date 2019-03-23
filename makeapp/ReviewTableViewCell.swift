//
//  ReviewTableViewCell.swift
//  makeapp
//
//  Created by Yulia on 23.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var textOfReview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
