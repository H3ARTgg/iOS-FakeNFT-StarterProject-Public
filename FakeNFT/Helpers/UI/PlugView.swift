import UIKit

final class PlugLabel: UILabel {
    func makePlugLabel() -> UILabel {
        let label = UILabel()
        
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlugLabel {
    func setupLabel() {
       translatesAutoresizingMaskIntoConstraints = false
       textColor = Asset.Colors.ypBlack.color
       textAlignment = .center
       font = Consts.Fonts.bold22
       isHidden = true
    }
}
