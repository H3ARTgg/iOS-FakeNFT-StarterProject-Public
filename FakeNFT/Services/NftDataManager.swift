//
//  NetworkManager.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation
<<<<<<< HEAD

protocol NftDataManagerProtocol {

=======
import Combine

protocol NftDataManagerProtocol {
    func getSetProfilePublisher(_ profile: ProfileEditUserViewModel?) -> AnyPublisher<ProfileResponseModel, NetworkError>
    func getNftsPublisher(nftIds: [String]) -> AnyPublisher<[NftResponseModel], NetworkError>
    func getUserNamesPublisher(ids: [String]) -> AnyPublisher<[String], NetworkError>
    func getUserNamePublisher(id: String) -> AnyPublisher<String, NetworkError>
    func removeFavoriteNft(_ id: String) -> AnyPublisher<ProfileResponseModel, NetworkError>
>>>>>>> develop
}

final class NftDataManager: NftDataManagerProtocol {
    private let networkService: NetworkClient
    
    init(networkService: NetworkClient) {
        self.networkService = networkService
    }
<<<<<<< HEAD
    
=======

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
    
    func getSetProfilePublisher(_ profile: ProfileEditUserViewModel? = nil) -> AnyPublisher<ProfileResponseModel, NetworkError> {
        var profileRequest: NetworkRequest
        
        if let profile {
            let profileToSend = ProfileEditResponseModel(name: profile.name,
                                                         description: profile.description,
                                                         website: profile.website,
                                                         likes: profile.likes)
            
            profileRequest = ProfileRequestPut(dto: profileToSend)
        } else {
            profileRequest = ProfileRequestGet()
        }
        
        let cancellable = networkService.networkPublisher(request: profileRequest,
                                                          type: ProfileResponseModel.self)
        return cancellable
    }
    
    func removeFavoriteNft(_ id: String) -> AnyPublisher<ProfileResponseModel, NetworkError> {
       getSetProfilePublisher().flatMap { [weak self] profileResponse in
            var likes = profileResponse.likes
            likes.removeAll(where: { $0 == id })
            
            let profile = ProfileEditUserViewModel(imageUrl: profileResponse.avatar,
                                                   name: profileResponse.name,
                                                   description: profileResponse.description,
                                                   website: profileResponse.website,
                                                   likes: likes)
           return self?.getSetProfilePublisher(profile) ??
                Empty<ProfileResponseModel, NetworkError>(completeImmediately: true).eraseToAnyPublisher()
        }
       .eraseToAnyPublisher()
    }
>>>>>>> develop
}
