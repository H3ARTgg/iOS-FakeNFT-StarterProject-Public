//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 23.06.2023.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol {
    var profileDataPublisher: AnyPublisher<ProfileUserViewModel?, NetworkError>? { get }
    var profileData: ProfileUserViewModel? { get }
    var ownedNfts: [String] { get }
    var favoriteNfts: [String] { get }
    
    func viewDidLoad()
    func setProfile(_ profile: ProfileEditUserViewModel)
}

final class ProfileViewModel {
    private let networkManager: NftDataManagerProtocol
    
    private(set) var profileDataPublisher: AnyPublisher<ProfileUserViewModel?, NetworkError>?
    private(set) var profileData: ProfileUserViewModel?
    private(set) var ownedNfts: [String] = []
    private(set) var favoriteNfts: [String] = []
    
    init(networkManager: NftDataManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    func viewDidLoad() {
        profileDataPublisher = networkManager.getProfilePublisher()
            .handleEvents(receiveOutput: { [weak self] profileResponse in
                self?.ownedNfts = profileResponse.nfts
                self?.favoriteNfts = profileResponse.likes
            })
            .map { [weak self] profileResponse in
                self?.convert(profileResponseData: profileResponse)
            }
            .handleEvents(receiveOutput: { [weak self] profileData in
                self?.profileData = profileData
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setProfile(_ profile: ProfileEditUserViewModel) {
        profileDataPublisher = networkManager.setProfilePublisher(profile, likes: favoriteNfts)
            .map { [weak self] profileResponse in
                self?.convert(profileResponseData: profileResponse)
            }
            .handleEvents(receiveOutput: { [weak self] profileData in
                self?.profileData = profileData
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension ProfileViewModel {
    func convert(profileResponseData: ProfileResponseModel) -> ProfileUserViewModel {
        ProfileUserViewModel(imageUrl: profileResponseData.avatar,
                             name: profileResponseData.name,
                             about: profileResponseData.description,
                             site: profileResponseData.website,
                             ownedNft: profileResponseData.nfts.count,
                             favoriteNft: profileResponseData.likes.count)
    }
}
