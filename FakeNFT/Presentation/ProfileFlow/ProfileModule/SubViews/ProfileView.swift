//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 22.06.2023.
//

import UIKit
import Kingfisher

final class ProfileView: UIView {
    var profileModel: ProfileUserViewModel? {
        didSet {
            guard let profileModel else {
                return
            }
            
            if let imageUrl = URL(string: profileModel.imageUrl) {
                userPicImageView.kf.setImage(with: imageUrl)
            }
            
            userNameLabel.text = profileModel.name
            aboutUserLabel.text = profileModel.about
            
            let link = profileModel.site
            let attributedString = NSMutableAttributedString(string: profileModel.site)
            let attributes: [NSAttributedString.Key: Any] = [.link: link,
                                                             .font: Consts.Fonts.regular15]
            
            attributedString.addAttributes(attributes,
                                           range: NSRange(location: 0,
                                                          length: link.count))
            
            siteLabel.attributedText = attributedString
        }
    }
    
    private let userPicSize: CGFloat = 70
    
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
        imageView.clipsToBounds = true
        imageView.tintColor = Asset.Colors.ypGrayUniversal.color
        imageView.backgroundColor = Asset.Colors.ypWhite.color
        imageView.layer.cornerRadius = userPicSize / 2
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        label.accessibilityIdentifier = "userNameLabel"
        return label
    }()
    
    private lazy var aboutUserLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.regular13
        label.numberOfLines = 10
        label.accessibilityIdentifier = "aboutUserLabel"
        label.setLineSpacing(lineSpacing: 3)
        return label
    }()
    
    private lazy var siteLabel: UITextView = {
        let textView = UITextView()
        textView.textColor = Asset.Colors.ypBlueUniversal.color
        textView.isScrollEnabled = false
        textView.accessibilityIdentifier = "siteLabel"
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
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
            
            userpicAndUsernameStack.heightAnchor.constraint(equalToConstant: userPicSize),
            
            userPicImageView.heightAnchor.constraint(equalTo: userpicAndUsernameStack.heightAnchor),
            userPicImageView.widthAnchor.constraint(equalTo: userPicImageView.heightAnchor)
        ])
    }
}
