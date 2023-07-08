//
//  FavoriteNftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 06.07.2023.
//

import UIKit

final class FavoriteNftCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteNftCollectionViewCell"
    
    var cellModel: NftViewModel? {
        didSet {
            guard let cellModel else { return }
            
            if let url = URL(string: cellModel.image) {
                nftImageView.kf.setImage(with: url)
            }
            
            nftTitleLabel.text = cellModel.name
            ratingStackView.setupRating(cellModel.rating)
            priceLabel.text = String(format: "%.2f", cellModel.price) + currency
        }
    }
    
    private let currency = " ETH"
    
    private var cellHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        return stack
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Asset.Colors.ypWhiteUniversal.color
        imageView.image = Asset.Assets.likeSet.image
        
        return imageView
    }()
    
    private var nftPropertiesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
    }()
    
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold17
        return label
    }()
    
    private lazy var ratingStackView = RatingStackView()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular15
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configure()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Subviews configure + layout
private extension FavoriteNftCollectionViewCell {
    func addSubviews() {
        contentView.addSubview(cellHStack)
        cellHStack.addArrangedSubview(nftImageView)
        cellHStack.addArrangedSubview(nftPropertiesStack)
        nftPropertiesStack.addArrangedSubview(nftTitleLabel)
        nftPropertiesStack.addArrangedSubview(ratingStackView)
        nftPropertiesStack.setCustomSpacing(8, after: ratingStackView)
        nftPropertiesStack.addArrangedSubview(priceLabel)
        nftImageView.addSubview(likeImageView)
    }
    
    func configure() {
        cellHStack.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            cellHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellHStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -6),
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 6)

        ])
    }
}
