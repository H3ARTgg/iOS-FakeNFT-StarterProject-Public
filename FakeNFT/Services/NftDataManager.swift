//
//  NetworkManager.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation

protocol NftDataManagerProtocol {

}

final class NftDataManager: NftDataManagerProtocol {
    private let networkService: NetworkClient
    
    init(networkService: NetworkClient) {
        self.networkService = networkService
    }
    
}
