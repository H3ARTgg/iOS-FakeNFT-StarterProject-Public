//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 22.06.2023.
//

import UIKit
import Kingfisher

final class ProfileView: UIView {
    
    var profileModel: ProfileData? {
        didSet {
            guard let profileModel else { return }
            userPicImageView.kf.setImage(with: profileModel.imageUrl)
            userNameLabel.text = profileModel.name
            aboutUserLabel.text = profileModel.about
            siteLabel.text = profileModel.site
        }
    }
    
    private var profileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 20
        return stack
    }()
    
    private var userpicAndUsernameStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private lazy var userPicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Consts.Images.profile
        imageView.clipsToBounds = true
        imageView.tintColor = Asset.Colors.ypGrayUniversal.color
        imageView.backgroundColor = Asset.Colors.ypWhite.color
        imageView.layer.cornerRadius = 70 / 2
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        label.text = "Joaquin Phoenix"
        label.accessibilityIdentifier = "userNameLabel"
        return label
    }()
    
    private lazy var aboutUserLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        label.numberOfLines = 4
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте.Открыт к коллаборациям."
        label.accessibilityIdentifier = "aboutUserLabel"
        label.setLineSpacing(lineSpacing: 3)
        return label
    }()
    
    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular15
        label.text = "Joaquin Phoenix.com"
        label.textColor = Asset.Colors.ypBlueUniversal.color
        label.accessibilityIdentifier = "siteLabel"
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
private extension ProfileView {
    func addSubviews() {
        addSubview(profileStack)
        profileStack.addArrangedSubview(userpicAndUsernameStack)
        profileStack.addArrangedSubview(aboutUserLabel)
        profileStack.setCustomSpacing(12, after: aboutUserLabel)
        userpicAndUsernameStack.addArrangedSubview(userPicImageView)
        userpicAndUsernameStack.addArrangedSubview(userNameLabel)
        profileStack.addArrangedSubview(siteLabel)
    }
    
    func configure() {
        profileStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            profileStack.topAnchor.constraint(equalTo: self.topAnchor),
            profileStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            userpicAndUsernameStack.heightAnchor.constraint(equalToConstant: 70),
            
            userPicImageView.heightAnchor.constraint(equalTo: userpicAndUsernameStack.heightAnchor),
            userPicImageView.widthAnchor.constraint(equalTo: userPicImageView.heightAnchor)
        ])
    }
}
