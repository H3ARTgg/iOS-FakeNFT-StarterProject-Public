//
//  ProfileEditCell.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 25.06.2023.
//

import UIKit
import Combine

final class ProfileEditCell: UITableViewCell, UITextViewDelegate {
    static let identifier = "ProfileEditCell"
    
    var cellText: String? {
        didSet {
            cellTextView.insertText(cellText ?? "")
        }
    }

    private(set) var cellOutput = PassthroughSubject<String, Never>()

    private lazy var cellTextView: UITextView = {
        let cellTextView = UITextView()
        cellTextView.font = Consts.Fonts.regular17
        cellTextView.textColor = Asset.Colors.ypBlack.color
        cellTextView.backgroundColor = .clear
        cellTextView.accessibilityIdentifier = "profileEditCellTextField"
        cellTextView.textContainerInset = .zero
        cellTextView.textContainer.lineFragmentPadding = 0
        cellTextView.delegate = self
        return cellTextView
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        cellOutput.send(textView.text)
    }
}

// MARK: - Subviews configure + layout

private extension ProfileEditCell {
    func addSubviews() {
        contentView.addSubview(cellTextView)
    }
    
    func configure() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = Asset.Colors.ypLightGray.color
        cellTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            cellTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            cellTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
            cellTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
