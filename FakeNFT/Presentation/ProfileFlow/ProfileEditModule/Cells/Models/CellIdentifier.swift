//
//  CellIdentifier.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation

enum CellIdentifier: String, Hashable {
    case name
    case description
    case website
    
    var localizedString: String {
        switch self {
        case .name: return Consts.LocalizedStrings.name
        case .description: return Consts.LocalizedStrings.description
        case .website: return Consts.LocalizedStrings.website
        }
    }
}
