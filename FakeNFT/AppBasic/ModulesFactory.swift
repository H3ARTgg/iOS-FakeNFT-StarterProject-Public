//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 02.07.2023.
//

import Foundation

protocol ModulesFactoryProtocol {
    func makeProfileView() -> Presentable

}

final class ModulesFactory: ModulesFactoryProtocol {
    
    func makeProfileView() -> Presentable {
        let networkService = DefaultNetworkClient()
        let networkManager = NftDataManager(networkService: networkService)
        let viewModel: ProfileViewModel = ProfileViewModel(networkManager: networkManager)
        let view = ProfileViewController(viewModel: viewModel)
        return view
    }
}
