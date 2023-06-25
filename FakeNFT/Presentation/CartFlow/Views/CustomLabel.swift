import UIKit

final class CustomLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        font = UIFont.bodyBold
        textColor = Asset.Colors.ypBlack.color
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
