//
//  ProfileDataModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 24.06.2023.
//

import Foundation

struct ProfileModel {
    let imageUrl: URL?
    let name: String
    let about: String
    let site: String
    let ownedNft: Int
    let favouriteNft: Int
}
