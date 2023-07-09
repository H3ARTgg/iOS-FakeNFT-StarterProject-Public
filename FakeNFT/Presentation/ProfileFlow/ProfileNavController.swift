//
//  ProfileNavController.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 22.06.2023.
//

import UIKit

final class ProfileNavController: UINavigationController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem(title: Consts.LocalizedStrings.profile,
                                       image: Consts.Images.profile,
                                       tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
