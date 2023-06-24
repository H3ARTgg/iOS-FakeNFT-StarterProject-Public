//
//  ProfileResponceModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 24.06.2023.
//

import Foundation

struct ProfileResponseModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
