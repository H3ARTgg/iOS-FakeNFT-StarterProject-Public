//
//  ProfileEditViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 27.06.2023.
//

import Foundation
import Combine

protocol ProfileEditCoordination {
    var finish: ((ProfileEditUserViewModel) -> Void)? { get set }
}

protocol ProfileEditViewModelProtocol {
    var numberOfSections: Int { get }
    var numberOfRowsInSections: Int { get }
    var urlForProfileImage: URL? { get }
    
    func cellDataForRow(_ index: Int) -> ProfileTableDataModel
    func storeText(_ text: String, at index: Int)
    func closeButtonTapped()
}

final class ProfileEditViewModel: ProfileEditCoordination {
    var finish: ((ProfileEditUserViewModel) -> Void)?
    
    private let profileEdit: ProfileEditUserViewModel
    
    private var profileTableData: [ProfileTableDataModel]
    
    init(profile: ProfileUserViewModel) {
        self.profileEdit = ProfileEditUserViewModel(imageUrl: profile.imageUrl,
                                                    name: profile.name,
                                                    description: profile.about,
                                                    website: profile.site,
                                                    likes: profile.favoriteNft)
        
        self.profileTableData = [
            ProfileTableDataModel(
                сellAppearance: .init(cellHeight: 46, cellIdentifier: .name),
                cellText: profileEdit.name
            ),
            ProfileTableDataModel(
                сellAppearance: .init(cellHeight: 132, cellIdentifier: .description),
                cellText: profileEdit.description
            ),
            ProfileTableDataModel(
                сellAppearance: .init(cellHeight: 46, cellIdentifier: .website),
                cellText: profileEdit.website
            )
        ]
    }
}

extension ProfileEditViewModel: ProfileEditViewModelProtocol {
    var numberOfSections: Int {
        profileTableData.count
    }
    
    var numberOfRowsInSections: Int {
        1
    }
    
    var urlForProfileImage: URL? {
        URL(string: profileEdit.imageUrl)
    }

    func cellDataForRow(_ index: Int) -> ProfileTableDataModel {
        profileTableData[index]
    }
    
    func storeText(_ text: String, at index: Int) {
        profileTableData[index] = ProfileTableDataModel(сellAppearance: profileTableData[index].сellAppearance, cellText: text)
    }
    
    func closeButtonTapped() {
        let newProfile = ProfileEditUserViewModel(imageUrl: profileEdit.imageUrl,
                                                  name: profileTableData[0].cellText,
                                                  description: profileTableData[1].cellText,
                                                  website: profileTableData[2].cellText,
                                                  likes: profileEdit.likes)
        
        finish?(newProfile)
    }
}
