import UIKit
import Kingfisher

final class CurrencyCollectionViewCell: UICollectionViewCell {
    
    private let currencyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let currencyImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let titleCurrencyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()
    
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    
    private let currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        label.textColor = Asset.Colors.ypGreenUniversal.color
        return label
    }()
    
    func configure() {
        contentView.backgroundColor = Asset.Colors.ypLightGray.color
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
//        currencyImageView.kf.setImage(with: URL(string: currency.image))
//        currencyNameLabel.text = currency.title
//        currencyShortNameLabel.text = currency.name
        
        addElements()
        setupConstraints()
    }
    
    private func addElements() {
        contentView.addSubview(currencyStackView)
        
        [
            currencyImageView,
            titleCurrencyStackView
        ].forEach { currencyStackView.addArrangedSubview($0) }
        
        [
            currencyNameLabel,
            currencyShortNameLabel
        ].forEach { titleCurrencyStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyStackView.heightAnchor.constraint(equalToConstant: 36),
            currencyStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 5
            ),
            currencyStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 12
            ),
            currencyStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -5
            ),
            currencyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -74)
        ])
    }
}
