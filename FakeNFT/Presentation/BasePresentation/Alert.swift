//
//  ActionSheet.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 02.07.2023.
//

import UIKit

struct AlertModel {
    let alertText: String
    let alertActions: [AlertAction]
}

struct AlertAction {
    let actionText: String
    let actionRole: ActionRole
    let action: (() -> Void)?
}

enum ActionRole {
    case regular, destructive, cancel
}
