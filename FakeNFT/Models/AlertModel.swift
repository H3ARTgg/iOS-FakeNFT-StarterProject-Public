import Foundation

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
