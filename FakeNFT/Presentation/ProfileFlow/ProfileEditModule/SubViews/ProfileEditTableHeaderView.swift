//
//  ProfileEditTableHeaderView.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 25.06.2023.
//

import UIKit
import Kingfisher

final class ProfileEditTableHeaderView: UIView {
    
    var userPicUrl: URL? {
        didSet {
            userPicImageView.kf.setImage(with: userPicUrl)
        }
    }
    
    var closeButtonClosure: (() -> Void)?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Consts.Images.cross, for: .normal)
        button.tintColor = Asset.Colors.ypBlack.color
        button.addTarget(nil, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var changePhoto: UIButton = {
        let button = UIButton()
        button.setTitle(Consts.LocalizedStrings.changePhoto, for: .normal)
        button.tintColor = Asset.Colors.ypWhiteUniversal.color
        button.titleLabel?.font = Consts.Fonts.medium10
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.layer.backgroundColor = Asset.Colors.ypGrayUniversal.color.withAlphaComponent(0.7).cgColor
        button.layer.cornerRadius = 70 / 2
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var userPicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = Asset.Colors.ypGrayUniversal.color
        imageView.backgroundColor = Asset.Colors.ypWhite.color
        imageView.layer.cornerRadius = 70 / 2
        return imageView
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

// MARK: - Private Methods

private extension ProfileEditTableHeaderView {
    @objc
    func closeButtonTapped() {
        closeButtonClosure?()
    }
}

// MARK: - Subviews configure + layout

private extension ProfileEditTableHeaderView {
    func addSubviews() {
        addSubview(closeButton)
        addSubview(userPicImageView)
        addSubview(changePhoto)
    }
    
    func configure() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        userPicImageView.translatesAutoresizingMaskIntoConstraints = false
        changePhoto.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            
            userPicImageView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            userPicImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userPicImageView.heightAnchor.constraint(equalToConstant: 70),
            userPicImageView.widthAnchor.constraint(equalTo: userPicImageView.heightAnchor),
            
            changePhoto.centerXAnchor.constraint(equalTo: userPicImageView.centerXAnchor),
            changePhoto.centerYAnchor.constraint(equalTo: userPicImageView.centerYAnchor),
            changePhoto.widthAnchor.constraint(equalToConstant: 70),
            changePhoto.heightAnchor.constraint(equalTo: userPicImageView.widthAnchor)
        ])
    }
}
