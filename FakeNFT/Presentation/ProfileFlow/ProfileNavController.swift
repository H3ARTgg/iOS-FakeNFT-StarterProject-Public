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
        let networkManager = NetworkManager(networkService: networkService)
        let viewModel: ProfileViewModel = ProfileViewModel(networkManager: networkManager)
        super.init(rootViewController: ProfileViewController(viewModel: viewModel))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
