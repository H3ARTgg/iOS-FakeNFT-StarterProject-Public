//
//  ProfileNavController.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 22.06.2023.
//

import UIKit

final class ProfileNavController: UINavigationController {
    
    init() {
        let networkService = DefaultNetworkClient()
        let viewModel: ProfileViewModel = ProfileViewModel(networkService: networkService)
        super.init(rootViewController: ProfileViewController(viewModel: viewModel))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
