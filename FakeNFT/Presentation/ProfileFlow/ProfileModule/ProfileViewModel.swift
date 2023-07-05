//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 23.06.2023.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol {
    var profileData: CurrentValueSubject<ProfileUserViewModel?, Never> { get }
    var ownedNfts: [String] { get }
    var favoriteNfts: [String] { get }
    
    func viewDidLoad()
    func setProfile(_ profile: ProfileEditUserViewModel)
}

final class ProfileViewModel {
    private(set) var profileData = CurrentValueSubject<ProfileUserViewModel?, Never>(nil)
    
    private let networkManager: NftDataManagerProtocol
    private(set) var profile: ProfileResponseModel?
    
    init(networkManager: NftDataManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    var ownedNfts: [String] {
        profile?.nfts ?? []
    }
    
    var favoriteNfts: [String] {
        profile?.likes ?? []
    }
    
    func setProfile(_ profile: ProfileEditUserViewModel) {
        networkManager.setProfile(profile, likes: self.profile?.likes ?? []) { data in
            DispatchQueue.main.async {
                self.profileData.send(self.convert(profileResponseData: data))
            }
        }
    }
    
    func viewDidLoad() {
        networkManager.getProfile { data in
            self.profile = data
            DispatchQueue.main.async {
                self.profileData.send(self.convert(profileResponseData: data))
            }
        }
    }
}

private extension ProfileViewModel {
    func convert(profileResponseData: ProfileResponseModel) -> ProfileUserViewModel {
        ProfileUserViewModel(imageUrl: profileResponseData.avatar,
                    name: profileResponseData.name,
                    about: profileResponseData.description,
                    site: profileResponseData.website,
                    ownedNft: profileResponseData.nfts.count,
                    favouriteNft: profileResponseData.likes.count)
    }
}