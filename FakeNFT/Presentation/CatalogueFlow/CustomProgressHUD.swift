import UIKit
import ProgressHUD

final class CustomProgressHUD {
    static func show() {
        setup()
        ProgressHUD.show()
    }
    
    static func dismiss() {
        setup()
        ProgressHUD.dismiss()
    }

    static private func setup() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = Asset.Colors.ypBackground.color
        ProgressHUD.colorAnimation = .lightGray
    }
}
