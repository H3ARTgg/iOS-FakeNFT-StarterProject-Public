//
//  NetworkManager.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation
import Combine

protocol NftDataManagerProtocol {
 
    func getProfilePublisher() -> AnyPublisher<ProfileResponseModel, NetworkError>
    func setProfilePublisher(_ profile: ProfileEditUserViewModel, likes: [String]) -> AnyPublisher<ProfileResponseModel, NetworkError>
    func getNftsPublisher(nftIds: [String]) -> AnyPublisher<[NftResponseModel], NetworkError>
    func getUserNamesPublisher(ids: [String]) -> AnyPublisher<[String], NetworkError>
    func getUserNamePublisher(id: String) -> AnyPublisher<String, NetworkError>
}

final class NftDataManager: NftDataManagerProtocol {
    private let networkService: NetworkClient
    
    init(networkService: NetworkClient) {
        self.networkService = networkService
    }

    private func getNftPublisher(nftId: String) -> AnyPublisher<NftResponseModel, NetworkError> {
        let nftGetRequest = NftGetRequest(id: nftId)
        return networkService.networkPublisher(request: nftGetRequest,
                                               type: NftResponseModel.self)
    }
    
    func getNftsPublisher(nftIds: [String]) -> AnyPublisher<[NftResponseModel], NetworkError> {
        nftIds.publisher
            .setFailureType(to: NetworkError.self)
            .flatMap(getNftPublisher)
            .collect()
            .eraseToAnyPublisher()
    }

    func getUserNamePublisher(id: String) -> AnyPublisher<String, NetworkError> {
        let userNameRequest = UserNameRequest(id: id)
        return networkService
            .networkPublisher(request: userNameRequest,
                              type: UserModel.self)
            .map { userModel in
                userModel.name
            }
            .eraseToAnyPublisher()
    }
    
    func getUserNamesPublisher(ids: [String]) -> AnyPublisher<[String], NetworkError> {
        ids.publisher
            .setFailureType(to: NetworkError.self)
            .flatMap(getUserNamePublisher)
            .collect()
            .eraseToAnyPublisher()
    }
    
    func getProfilePublisher() -> AnyPublisher<ProfileResponseModel, NetworkError> {
        let profileRequestGet = ProfileRequestGet()
        let cancellable = networkService.networkPublisher(request: profileRequestGet,
                                                          type: ProfileResponseModel.self)
        return cancellable
    }
    
    func setProfilePublisher(_ profile: ProfileEditUserViewModel, likes: [String]) -> AnyPublisher<ProfileResponseModel, NetworkError> {
        let profileToSend = ProfileEditResponseModel(name: profile.name,
                                                     description: profile.description,
                                                     website: profile.website,
                                                     likes: likes)
        
        let profileRequestPut = ProfileRequestPut(dto: profileToSend)
        let cancellable = networkService.networkPublisher(request: profileRequestPut,
                                                          type: ProfileResponseModel.self)
        return cancellable
    }
}
