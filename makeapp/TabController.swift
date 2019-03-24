//
//  TabController.swift
//  makeapp
//
//  Created by Yulia on 24.03.2019.
//  Copyright © 2019 Yulia. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.barTintColor = UIColor(red: 227.0/255.0, green: 197.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    }
}
