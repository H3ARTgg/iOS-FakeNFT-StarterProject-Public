//
//  NftViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 08.07.2023.
//

import Foundation

struct NftViewModel: Hashable {
    let id: String
    let image: String
    let name: String
    let rating: Int
    let author: String
    let price: Double
    let isLiked: Bool
}
