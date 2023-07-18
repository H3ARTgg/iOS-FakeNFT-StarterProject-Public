//
//  UserModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 08.07.2023.
//

import Foundation

struct UserModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
