//
//  NetworkManager.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation

protocol NftDataManagerProtocol {
    func setProfile(_ profile: ProfileEditUserViewModel, likes: [String], handler: @escaping (ProfileResponseModel) -> Void)
    func getProfile(handler: @escaping (ProfileResponseModel) -> Void)
    func getNft(nftId: String, handler: @escaping (NftResponseModel) -> Void)
}


final class NftDataManager: NftDataManagerProtocol {
    private let networkService: NetworkClient
    
    init(networkService: NetworkClient) {
        self.networkService = networkService
    }
    
    func setProfile(_ profile: ProfileEditUserViewModel, likes: [String], handler: @escaping (ProfileResponseModel) -> Void) {
        let profileToSend = ProfileEditResponseModel(name: profile.name,
                                                     description: profile.description,
                                                     website: profile.website,
                                                     likes: likes)
        let profileRequestPut = ProfileRequestPut(dto: profileToSend)
        
        networkService.send(request: profileRequestPut, type: ProfileResponseModel.self) { result in
            switch result {
            case .success(let data): handler(data)
            case .failure(let error): print("ERROR ", error.localizedDescription)
            }
        }
    }
    
    func getProfile(handler: @escaping (ProfileResponseModel) -> Void) {
        let profileRequestGet = ProfileRequestGet()
        networkService.send(request: profileRequestGet, type: ProfileResponseModel.self) { result in
            switch result {
            case .success(let data): handler(data)
            case .failure(let error): print("ERROR ", error.localizedDescription)
            }
        }
    }
    
    func getNft(nftId: String, handler: @escaping (NftResponseModel) -> Void) {
        let nftGetRequest = NftGetRequest(id: nftId)
        networkService.send(request: nftGetRequest, type: NftResponseModel.self) { result in
            switch result {
            case .success(let data): handler(data)
            case .failure(let error): print("ERROR ", error.localizedDescription)
            }
        }
    }
}
