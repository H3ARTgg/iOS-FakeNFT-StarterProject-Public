//
//  ProfileEditUserModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 27.06.2023.
//

import Foundation

struct ProfileEditUserModel {
    let name: String
    let description: String
    let website: String
    let likes: [String]
}

struct ProfileEditUserViewModel {
    let imageUrl: String
    let name: String
    let description: String
    let site: String
}