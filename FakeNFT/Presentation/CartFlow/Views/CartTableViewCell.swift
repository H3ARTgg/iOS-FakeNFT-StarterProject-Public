import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = Consts.Cart.ProductImageView.imageProductRadius
        return view
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productTitleLabel = CustomLabel(text: "")
    
    private let productRatingStackView = RatingStackView()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.price
        label.font = UIFont.caption2
        label.textColor = Asset.Colors.ypBlack.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productTotalPriceLabel = CustomLabel(text: "")
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Asset.Assets.cartButton.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(deleteNft),
            for: .touchUpInside
        )
        return button
    }()
    
    var nft: Nft?
    weak var delegate: CartViewControllerDelegate?
    
    // MARK: - Helpers
    func configure(_ nft: Nft) {
        backgroundColor = .clear
        addElements()
        setupConstraints()
        
        self.nft = nft
        
        productTitleLabel.text = nft.name
        productImageView.kf.setImage(with: URL(string: nft.image))
        productTotalPriceLabel.text = (String(format: "%.2f", nft.price) + " \(L10n.Label.Currency.eth)").replacingOccurrences(of: ".", with: ",")
        setupRating(nft)
    }
    
    // MARK: - Actions
    @objc private func deleteNft() {
        delegate?.openDeleteNftViewController(nft)
    }
}

// MARK: - Private methods
extension CartTableViewCell {
    private func addElements() {
        [
            productImageView,
            detailView,
            deleteButton
        ].forEach { contentView.addSubview($0) }
        
        [
            productTitleLabel,
            productRatingStackView,
            productPriceLabel,
            productTotalPriceLabel
        ].forEach { detailView.addSubview($0) }
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(
                equalToConstant: Consts.Cart.ProductImageView.heightProductImageView
            ),
            productImageView.widthAnchor.constraint(
                equalTo: productImageView.heightAnchor
            ),
            productImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16
            ),
            productImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 16
            ),
            productImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -16
            ),

            detailView.topAnchor.constraint(
                equalTo: productImageView.topAnchor, constant: 8
            ),
            detailView.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 20
            ),
            detailView.bottomAnchor.constraint(
                equalTo: productImageView.bottomAnchor, constant: -8
            ),
            
            productTitleLabel.topAnchor.constraint(
                equalTo: detailView.topAnchor
            ),
            productTitleLabel.leadingAnchor.constraint(
                equalTo: detailView.leadingAnchor
            ),
            
            productRatingStackView.widthAnchor.constraint(
                equalToConstant: Consts.Cart.ProductRating.widthProductRating
            ),
            productRatingStackView.topAnchor.constraint(
                equalTo: productTitleLabel.bottomAnchor, constant: 4
            ),
            productRatingStackView.leadingAnchor.constraint(
                equalTo: detailView.leadingAnchor
            ),
            productRatingStackView.heightAnchor.constraint(equalToConstant: 12),
            
            productPriceLabel.topAnchor.constraint(
                equalTo: productRatingStackView.bottomAnchor, constant: 12
            ),
            productPriceLabel.leadingAnchor.constraint(
                equalTo: detailView.leadingAnchor
            ),
            
            productTotalPriceLabel.topAnchor.constraint(
                equalTo: productPriceLabel.bottomAnchor, constant: 2
            ),
            productTotalPriceLabel.leadingAnchor.constraint(
                equalTo: detailView.leadingAnchor
            ),
            
            deleteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),
            deleteButton.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            )
        ])
    }
    
    private func setupRating(_ nft: Nft) {
        for view in productRatingStackView.subviews {
            if let imageView = view as? UIImageView {
                imageView.image = Asset.Assets.star.image
            }
        }
        
        let rating = nft.rating
        
        for index in 0..<rating {
            if let fullStar = productRatingStackView.subviews[index] as? UIImageView {
                fullStar.image = Asset.Assets.fillStar.image
            }
        }
    }
}
