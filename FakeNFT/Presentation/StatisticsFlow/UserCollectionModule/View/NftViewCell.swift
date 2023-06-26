import Foundation
import UIKit

final class NftViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: Helper
    static var defaultReuseIdentifier: String { "NftViewCell" }
    
    private struct CellConstants {
        static let cartButtonWidth: CGFloat = 44
        static let viewIndent: CGFloat = 5
        static let ratingViewHeight: CGFloat = 10
    }
    
    // MARK: private properties
    private var viewModel: NftViewCellViewModelProtocol?
    
    // MARK: UI
    private lazy var nftImageView = makeNftImageView()
    private lazy var likeButton = makeLikeButton()
    private lazy var ratingView = makeRatingView()
    private lazy var nftNameLabel = makeNftNameLabel()
    private lazy var nftPriceLabel = makeNftPriceLabel()
    private lazy var stackView = makeStackView()
    private lazy var buttonAndLablesStackStackView = makeButtonAndLablesStackStackView()
    private lazy var lablesView = makeLablesView()
    private lazy var cartButton = makeCartButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
        addViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    public func initialize(viewModel: NftViewCellViewModelProtocol?) {
        self.viewModel = viewModel
        bind()
    }
}

extension NftViewCell {
    private func makeNftImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func makeLikeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.setImage(Asset.Assets.like.image, for: .normal)
        button.backgroundColor = .clear
        return button
    }
    
    private func makeRatingView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func makeNftNameLabel() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.bodyBold
        return label
    }
    
    private func makeNftPriceLabel() -> UILabel {
        let label = makeLabel()
        label.font = Consts.Fonts.medium10
        return label
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.textAlignment = .left
        return label
    }
    
    private func makeCartButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.setImage(Asset.Assets.cart.image, for: .normal)
        button.tintColor = Asset.Colors.ypBlack.color
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        return button
    }
    
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        return stackView
    }
    
    private func makeLablesView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }
    
    private func makeButtonAndLablesStackStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        return stackView
    }
    
    private func viewSetup() {
        contentView.backgroundColor = .clear
    }
    
    private func addViews() {
        [stackView, likeButton].forEach {
            contentView.addSubview($0)
        }
        
        [nftImageView, ratingView, buttonAndLablesStackStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [nftNameLabel, nftPriceLabel].forEach {
            lablesView.addSubview($0)
        }
        
        [lablesView, cartButton].forEach {
            buttonAndLablesStackStackView.addArrangedSubview($0)
        }
    }
    
    private func activateConstraints() {
        let nftImageViewWidth = contentView.bounds.width
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: CellConstants.cartButtonWidth),
            
            nftImageView.widthAnchor.constraint(equalToConstant: nftImageViewWidth),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: lablesView.topAnchor, constant: CellConstants.viewIndent),
            nftNameLabel.widthAnchor.constraint(equalTo: lablesView.widthAnchor),
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: CellConstants.viewIndent),
            nftPriceLabel.widthAnchor.constraint(equalTo: lablesView.widthAnchor),
            
            ratingView.heightAnchor.constraint(equalToConstant: CellConstants.ratingViewHeight),
            
            buttonAndLablesStackStackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: CellConstants.cartButtonWidth),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
            likeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: CellConstants.viewIndent),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -CellConstants.viewIndent)
        ])
    }
    
    private func bind() {
        
    }
    
    @objc
    private func cartButtonTapped() {
        print("add to cart")
    }
    
    @objc
    private func likeButtonTapped() {
        print("Like")
    }
}
