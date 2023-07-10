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
            guard let cellModel
            else {
                cellText.text = ""
                return
            }
            
            cellText.text = cellModel.text + (cellModel.amount != nil ? " (\(cellModel.amount!))" : "")
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
        imageView.image = Consts.Images.chevron
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
        addSubview(cellText)
        addSubview(indicator)
    }
    
    func configure() {
        backgroundColor = .clear
        cellText.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            cellText.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellText.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellText.trailingAnchor.constraint(equalTo: indicator.leadingAnchor),
            
            indicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
