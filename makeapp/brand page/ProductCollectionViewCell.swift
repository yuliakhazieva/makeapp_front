//
//  ProductCollectionViewCell.swift
//  makeapp
//
//  Created by Yulia on 03.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: ProductModel) {
        productImage.image = model.image
        productLabel.text = model.name
    }
}
