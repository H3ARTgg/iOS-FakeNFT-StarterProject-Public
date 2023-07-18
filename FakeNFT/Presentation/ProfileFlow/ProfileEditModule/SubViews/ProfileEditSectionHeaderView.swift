//
//  ProfileEditHeaderView.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 25.06.2023.
//

import UIKit

final class ProfileEditSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ProfileEditSectionHeaderView"
    
    var headerText: String? {
        didSet {
            titleLabel.text = headerText
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        configure()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Subviews configure + layout

private extension ProfileEditSectionHeaderView {
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
