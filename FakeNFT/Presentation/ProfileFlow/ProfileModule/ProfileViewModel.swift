//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 23.06.2023.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol {
    var profileData: PassthroughSubject<ProfileData, Never> { get }
    
    func viewDidLoad()
}

final class ProfileViewModel {
    var profileData = PassthroughSubject<ProfileData, Never>()
    
}

extension ProfileViewModel: ProfileViewModelProtocol {
    func viewDidLoad() {
        profileData
            .send(ProfileData(imageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Yandex_icon.svg/1024px-Yandex_icon.svg.png")!,
                              name: "Harry Potter",
                              about: "dsfasdfasdfasdfgasdfas",
                              site: "apple.com",
                             ownedNft: 112,
                             favouriteNft: 11))
    }
}


struct ProfileData {
    let imageUrl: URL
    let name: String
    let about: String
    let site: String
    let ownedNft: Int
    let favouriteNft: Int
}
