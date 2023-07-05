//
//  ProfileEditViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 27.06.2023.
//

import Foundation
import Combine

protocol ProfileEditViewModelProtocol {
    var profileTableData: PassthroughSubject<Void, Never> { get }
    var numberOfSections: Int { get }
    var numberOfRowsInSections: Int { get }
    var urlForProfileImage: URL? { get }
    
    func cellDataForRow(_ index: Int) -> ProfileTableDataModel
    func storeText(_ text: String, at index: Int)
    func closeButtonTapped()
}

final class ProfileEditViewModel {
    var profileTableData = PassthroughSubject<Void, Never>()
    
    var numberOfSections: Int {
        profileData.count
    }
    
    var numberOfRowsInSections: Int {
        1
    }
    
    var urlForProfileImage: URL? {
        URL(string: profile.imageUrl)
    }
    
    private let profile: ProfileEditUserViewModel
    private var profileData: [ProfileTableDataModel]

    private let saveCallback: ((ProfileEditUserViewModel) -> Void)?
    
    init(profile: ProfileEditUserViewModel, saveCallback: ((ProfileEditUserViewModel) -> Void)?) {
        self.profile = profile
        self.saveCallback = saveCallback
        self.profileData = [ProfileTableDataModel(сellAppearance: .init(cellHeight: 46, cellIdentifier: .name),
                                                  cellText: profile.name),
                            ProfileTableDataModel(сellAppearance: .init(cellHeight: 132, cellIdentifier: .description),
                                                  cellText: profile.description),
                            ProfileTableDataModel(сellAppearance: .init(cellHeight: 46, cellIdentifier: .website),
                                                  cellText: profile.website)]
    }
}

extension ProfileEditViewModel: ProfileEditViewModelProtocol {
    func setProfile(_ profile: ProfileEditUserViewModel) {
        
    }
    
    func cellDataForRow(_ index: Int) -> ProfileTableDataModel {
        profileData[index]
    }
    
    func storeText(_ text: String, at index: Int) {
        profileData[index] = ProfileTableDataModel(сellAppearance: profileData[index].сellAppearance, cellText: text)
    }
    
    func closeButtonTapped() {
        let newProfile = ProfileEditUserViewModel(imageUrl: profile.imageUrl,
                                                  name: profileData[0].cellText,
                                                  description: profileData[1].cellText,
                                                  website: profileData[2].cellText)
        saveCallback?(newProfile)
        
    }
}