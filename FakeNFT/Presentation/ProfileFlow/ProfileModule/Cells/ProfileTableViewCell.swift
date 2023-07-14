//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 22.06.2023.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"
    
    var cellModel: ProfileCellModel? {
        didSet {
            guard let cellModel, let amount = cellModel.amount
            else {
                cellText.text = cellModel?.text
                return
            }
            
            cellText.text = cellModel.text + " " + L10n.profileNfts(amount)
        }
    }
    
    private lazy var cellText: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold17
        label.textColor = Asset.Colors.ypBlack.color
        label.accessibilityIdentifier = "userNameLabel"
        return label
    }()
    
    private lazy var indicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Consts.Images.chevron?.imageFlippedForRightToLeftLayoutDirection()
        imageView.tintColor = Asset.Colors.ypBlack.color
        return imageView
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
}

// MARK: - Subviews configure + layout
private extension ProfileTableViewCell {
    func addSubviews() {
        contentView.addSubview(cellText)
        contentView.addSubview(indicator)
    }
    
    func configure() {
        backgroundColor = .clear
        cellText.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            cellText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            //cellText.trailingAnchor.constraint(equalTo: indicator.leadingAnchor),
            
            indicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
