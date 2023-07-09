//
//  ModulesFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 02.07.2023.

import Foundation

protocol ModulesFactoryProtocol {
    func makeProfileView() -> (view: Presentable, coordination: ProfileCoordination)
    func makeProfileEditView(profileData: ProfileUserViewModel) -> (view: Presentable, coordination: ProfileEditCoordination)
    func makeOwnedNftView(ownedNfts: [String]) -> (view: Presentable, coordination: OwnedNftCoordination)
    func makeFavoriteNftView(favoriteNfts: [String]) -> (view: Presentable, coordination: FavoriteNftCoordination)
    func makeAboutWebView(urlString: String) -> Presentable
}

struct ModulesFactory: ModulesFactoryProtocol {
    let networkManager: NftDataManagerProtocol = NftDataManager(networkService: DefaultNetworkClient())
}

// MARK: - Profile Flow

extension ModulesFactory {
    func makeProfileView() -> (view: Presentable, coordination: ProfileCoordination) {
        let profileViewModel = ProfileViewModel(networkManager: networkManager)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        return (profileViewController, profileViewModel)
    }
    
    func makeProfileEditView(profileData: ProfileUserViewModel) -> (view: Presentable, coordination: ProfileEditCoordination) {
        let profileEditViewModel = ProfileEditViewModel(profile: profileData)
        let profileEditViewController = ProfileEditTableView(viewModel: profileEditViewModel)
        return (profileEditViewController, profileEditViewModel)
    }
    
    func makeOwnedNftView(ownedNfts: [String]) -> (view: Presentable, coordination: OwnedNftCoordination) {
        let ownedNftViewModel = OwnedNftViewModel(networkManager: networkManager, ownedNfts: ownedNfts)
        let ownedNftViewController = OwnedNftViewController(viewModel: ownedNftViewModel)
        return (ownedNftViewController, ownedNftViewModel)
    }
    
    func makeFavoriteNftView(favoriteNfts: [String]) -> (view: Presentable, coordination: FavoriteNftCoordination) {
        let favoriteNftViewModel = FavoriteNftViewModel(ownedNfts: favoriteNfts)
        let favoriteNftViewController = FavoriteNftViewController(viewModel: favoriteNftViewModel)
        return (favoriteNftViewController, favoriteNftViewModel)
    }
    
    func makeAboutWebView(urlString: String) -> Presentable {
        let url = URL(string: urlString)
        let webViewViewModel = WebViewViewModel(url: url)
        let webViewController = WebViewViewController(viewModel: webViewViewModel)
        return webViewController
    }
}
