//
//  ProfileEditResponseModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 08.07.2023.
//

import Foundation

struct ProfileEditResponseModel: Encodable {
    let name: String
    let description: String
    let website: String
    let likes: [String]
}
