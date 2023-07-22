import UIKit
import Kingfisher

final class NftViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: Helper
    static var defaultReuseIdentifier: String { "NftViewCell" }
    
    private struct CellConstants {
        static let cartButtonWidth: CGFloat = 44
        static let viewIndent: CGFloat = 5
        static let ratingViewHeight: CGFloat = 10
        static let cornerRadius: CGFloat = 12
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
    private lazy var ratingStackView = makeRatingStackView()
    
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
    func initialize(viewModel: NftViewCellViewModelProtocol?) {
        self.viewModel = viewModel
        bind()
    }
}

private extension NftViewCell {
    func makeNftImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CellConstants.cornerRadius
        return imageView
    }
    
    func makeLikeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }
    
    func makeRatingView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeNftNameLabel() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.bodyBold
        return label
    }
    
    func makeNftPriceLabel() -> UILabel {
        let label = makeLabel()
        label.font = Consts.Fonts.medium10
        return label
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.textAlignment = .left
        return label
    }
    
    func makeCartButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.setImage(Asset.Assets.cart.image, for: .normal)
        button.tintColor = Asset.Colors.ypBlack.color
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        return button
    }
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }
    
    func makeLablesView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }
    
    func makeButtonAndLablesStackStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        return stackView
    }
    
    func makeRatingStackView() -> RatingStackView {
        let stackView = RatingStackView()
        return stackView
    }
    
    func viewSetup() {
        contentView.backgroundColor = .clear
    }
    
    func addViews() {
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
        
        ratingView.addSubview(ratingStackView)
    }
    
    func activateConstraints() {
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
            
            ratingView.heightAnchor.constraint(equalTo: ratingStackView.heightAnchor),
            ratingStackView.leftAnchor.constraint(equalTo: ratingView.leftAnchor),
            ratingStackView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: CellConstants.cartButtonWidth),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
            likeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: CellConstants.viewIndent),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -CellConstants.viewIndent)
        ])
    }
    
    func bind() {
        guard var viewModel else { return }
        nftNameLabel.text = viewModel.nftName
        nftPriceLabel.text = viewModel.nftPrice
        ratingStackView.setupRating(viewModel.rating)
        setLikeImage(isLiked: viewModel.like)
        addCartImage(isInCart: viewModel.isInCart)
        loadImage()
        
        viewModel.setLike = { [weak self] isLike in
            guard let self else { return }
            self.setLikeImage(isLiked: isLike)
        }

        viewModel.addToCart = { [weak self] isInCart in
            guard let self else { return }
            self.addCartImage(isInCart: isInCart)
        }
    }
    
    func setLikeImage(isLiked: Bool) {
        let image = isLiked ? Asset.Assets.likeSet.image : Asset.Assets.noLike.image
        likeButton.setImage(image, for: .normal)
    }

    func addCartImage(isInCart: Bool) {
        let image = isInCart ? Asset.Assets.inCart.image : Asset.Assets.cart.image
        cartButton.setImage(image, for: .normal)
    }
    
    func loadImage() {
        guard let url = viewModel?.imageURL else { return }
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(with: url)
    }
    
    @objc
    func cartButtonTapped() {
        viewModel?.cartButtonTapped()
    }
    
    @objc
    func likeButtonTapped() {
        viewModel?.likeButtonTapped()
    }
}
