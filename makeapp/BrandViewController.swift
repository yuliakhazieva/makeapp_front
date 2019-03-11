//
//  BrandViewController.swift
//  makeapp
//
//  Created by Yulia on 24.01.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit

class BrandViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var brandName = String()
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = brandName
    }
}
