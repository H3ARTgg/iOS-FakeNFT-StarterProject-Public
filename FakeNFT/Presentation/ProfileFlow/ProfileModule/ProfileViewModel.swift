//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 23.06.2023.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol {
    var profileData: PassthroughSubject<ProfileModel, Never> { get }
    
    func viewDidLoad()
}

final class ProfileViewModel {
    var profileData = PassthroughSubject<ProfileModel, Never>()
    
    private let networkService: NetworkClient
    
    init(networkService: NetworkClient) {
        self.networkService = networkService
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    func viewDidLoad() {
        getProfile()
    }
}

private extension ProfileViewModel {
    func getProfile() {
        let profileRequestGet = ProfileRequestGet()
        networkService.send(request: profileRequestGet, type: ProfileResponseModel.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.profileData.send(self.convert(profileResponceData: data))
                }
                
            case .failure(let error): print("ERROR ", error.localizedDescription)
            }
        }
    }
    
    func convert(profileResponceData: ProfileResponseModel) -> ProfileModel {
        ProfileModel(imageUrl: URL(string: profileResponceData.avatar),
                    name: profileResponceData.name,
                    about: profileResponceData.description,
                    site: profileResponceData.website,
                    ownedNft: profileResponceData.nfts.count,
                    favouriteNft: profileResponceData.likes.count)
    }
}
