//
//  NftResponseModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 08.07.2023.
//

import Foundation

struct NftResponseModel: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
