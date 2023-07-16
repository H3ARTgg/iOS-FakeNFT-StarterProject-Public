import Foundation

protocol ErrorHandlerProtocol {
    func createErrorAlertModel(message: String, completion: @escaping (() -> Void)) -> AlertModel
}

struct ErrorHandler: ErrorHandlerProtocol {
    
    func createErrorAlertModel(message: String, completion: @escaping (() -> Void)) -> AlertModel {
        let alertText = L10n.Statistic.ErrorAlert.title
        let alertRepeatActionText = L10n.Statistic.AlertAction.Repeat.title
        let alertCancelText = L10n.Statistic.AlertAction.Cancel.title
        
        let alertRepeatAction = AlertAction(
            actionText: alertRepeatActionText,
            actionRole: .regular,
            action: completion)
        
        let alertCancelAction = AlertAction(actionText: alertCancelText, actionRole: .cancel, action: nil)
        
        let alertModel = AlertModel(
            alertText: alertText,
            message: message,
            alertActions: [alertCancelAction, alertRepeatAction]
        )
        return alertModel
    }
}
