//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 23.06.2023.
//

import Foundation
import Combine

protocol ProfileCoordination: AnyObject {
    var headForEditProfile: ((ProfileUserViewModel) -> Void)? { get set }
    var headForOwnedNfts: (([String]) -> Void)? { get set }
    var headForFavoriteNfts: (([String]) -> Void)? { get set }
    var headForAbout: ((String) -> Void)? { get set }
    var headForError: ((String) -> Void)? { get set }
    
    func setProfile(_ profile: ProfileEditUserViewModel)
    func onReturnFromFavorites(_ favoriteNfts: [String])
}

protocol ProfileViewModelProtocol {
    var profileDataPublisher: AnyPublisher<ProfileUserViewModel?, NetworkError>? { get }
    var getSetProfile: PassthroughSubject<ProfileEditUserViewModel?, NetworkError> { get }
    var showLoading: PassthroughSubject<Bool, Never> { get }
    
    func requestProfile()
    
    func editProfileTapped()
    func ownedNftsTapped()
    func favoritesNftsTapped()
    func aboutTapped()
}

final class ProfileViewModel {
    var headForEditProfile: ((ProfileUserViewModel) -> Void)?
    var headForOwnedNfts: (([String]) -> Void)?
    var headForFavoriteNfts: (([String]) -> Void)?
    var headForAbout: ((String) -> Void)?
    var headForError: ((String) -> Void)?
    
    private(set) var profileDataPublisher: AnyPublisher<ProfileUserViewModel?, NetworkError>?
    private(set) var getSetProfile = PassthroughSubject<ProfileEditUserViewModel?, NetworkError>()
    private(set) var showLoading = PassthroughSubject<Bool, Never>()
    
    private var profileData: ProfileUserViewModel?
    private var ownedNfts: [String] = []
    private var favoriteNfts: [String] = []
    
    init(networkManager: NftDataManagerProtocol) {
        profileDataPublisher = getSetProfile.flatMap { [weak self] profile in
            self?.showLoading.send(true)
            return networkManager.getSetProfilePublisher(profile)
                .handleEvents(receiveOutput: { [weak self] profileResponse in
                    self?.ownedNfts = profileResponse.nfts
                    self?.favoriteNfts = profileResponse.likes
                })
                .map { [weak self] profileResponse in
                    self?.convert(profileResponseData: profileResponse)
                }
                .handleEvents(receiveOutput: { [weak self] profileData in
                    self?.profileData = profileData
                    self?.showLoading.send(false)
                })
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCompletion: { [weak self] completion in
                    self?.showLoading.send(false)
                    if case .failure(let error) = completion {
                        self?.headForError?(error.localizedDescription)
                    }
                })
                .receive(on: DispatchQueue.main)
        }
        .eraseToAnyPublisher()
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {

    func requestProfile() {
        getSetProfile.send(nil)
    }
    
    func editProfileTapped() {
        guard let profileData else {
            return
        }
        
        headForEditProfile?(profileData)
    }
    
    func ownedNftsTapped() {
        headForOwnedNfts?(ownedNfts)
    }
    
    func favoritesNftsTapped() {
        headForFavoriteNfts?(favoriteNfts)
    }
    
    func aboutTapped() {
        headForAbout?("https://practicum.yandex.ru/profile/ios-developer/")
    }
}

extension ProfileViewModel: ProfileCoordination {
    func setProfile(_ profile: ProfileEditUserViewModel) {
        getSetProfile.send(profile)
    }
    
    func onReturnFromFavorites(_ favoriteNfts: [String]) {
        getSetProfile.send(nil)
    }
}

private extension ProfileViewModel {
    func convert(profileResponseData: ProfileResponseModel) -> ProfileUserViewModel {
        ProfileUserViewModel(imageUrl: profileResponseData.avatar,
                             name: profileResponseData.name,
                             about: profileResponseData.description,
                             site: profileResponseData.website,
                             ownedNft: profileResponseData.nfts,
                             favoriteNft: profileResponseData.likes)
    }
}
