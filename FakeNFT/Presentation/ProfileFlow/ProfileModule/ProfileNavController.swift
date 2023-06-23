//
//  ProfileNavController.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 22.06.2023.
//

import UIKit

final class ProfileNavController: UINavigationController {
    
    init() {
        super.init(rootViewController: ProfileViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
