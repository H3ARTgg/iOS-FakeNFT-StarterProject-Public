//
//  ProfileTableDataModel.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import Foundation

struct ProfileTableDataModel {
    let сellAppearance: CellAppearanceModel
    let cellText: String
}

struct CellAppearanceModel: Hashable {
    let cellHeight: CGFloat
    let cellIdentifier: CellIdentifier
}
