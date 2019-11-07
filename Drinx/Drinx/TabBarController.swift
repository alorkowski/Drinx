//
//  TabBarController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/25/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in self.viewControllers! {
            vc.tabBarItem.title = nil
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
