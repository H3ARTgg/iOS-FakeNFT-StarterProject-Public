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
        case .name: return L10n.Profile.name
        case .description: return L10n.Profile.about
        case .website: return L10n.Profile.site
        }
    }
}
