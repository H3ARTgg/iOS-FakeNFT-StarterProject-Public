//
//  OwnedNftTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 01.07.2023.
//

import UIKit
import Kingfisher

final class OwnedNftTableViewCell: UITableViewCell {
    
    static let identifier = "OwnedNftTableViewCell"

    var cellModel: NftViewModel? {
        didSet {
            guard let cellModel else { return }
            
            if let url = URL(string: cellModel.image) {
                nftImageView.kf.setImage(with: url)
            }
            
            nftTitleLabel.text = cellModel.name
            ratingStackView.setupRating(cellModel.rating)
            authorNameLabel.text = cellModel.author
            priceLabel.text = String(format: "%.3f", cellModel.price) + currency
        }
    }
    
    private let currency = " ETH"
    
    private var cellHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
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
        imageView.image = Asset.Assets.like.image
        
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
     
    private var nameStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular15
        label.text = "от" // TODO: Localization
        return label
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        return label
    }()
    
    private var nftPriceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 2
        return stack
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        label.text = "Цена" // TODO: Localization
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold17
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configure()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 39))
    }
}

// MARK: - Subviews configure + layout
private extension OwnedNftTableViewCell {
    func addSubviews() {
        contentView.addSubview(cellHStack)
        cellHStack.addArrangedSubview(nftImageView)
        cellHStack.setCustomSpacing(20, after: nftImageView)
        cellHStack.addArrangedSubview(nftPropertiesStack)
        nftPropertiesStack.addArrangedSubview(nftTitleLabel)
        nftPropertiesStack.addArrangedSubview(ratingStackView)
        nftPropertiesStack.addArrangedSubview(nameStack)
        nameStack.addArrangedSubview(fromLabel)
        nameStack.addArrangedSubview(authorNameLabel)
        cellHStack.addArrangedSubview(nftPriceStack)
        nftPriceStack.addArrangedSubview(priceTitleLabel)
        nftPriceStack.addArrangedSubview(priceLabel)
        
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
            
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12),
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12)

        ])
    }
}
