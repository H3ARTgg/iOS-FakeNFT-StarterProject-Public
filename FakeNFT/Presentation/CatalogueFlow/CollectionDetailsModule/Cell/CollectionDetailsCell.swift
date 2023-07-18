import UIKit

final class CollectionDetailsCell: UICollectionViewCell, ReuseIdentifying {
    private var ratingStackView: UIStackView? {
        didSet {
            setupRatingStackView()
        }
    }
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold17
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.medium10
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    private lazy var cartButton: UIButton = {
        let button = UIButton.systemButton(with: Consts.Images.outCart, target: self, action: #selector(didTapCart))
        button.tintColor = Asset.Colors.ypBlack.color
        return button
    }()
    private lazy var favoriteButton: UIButton = {
        let button = UIButton.systemButton(with: Consts.Images.outFavorites, target: self, action: #selector(didTapFavorite))
        button.tintColor = Asset.Colors.ypWhiteUniversal.color
        return button
    }()
        var viewModel: CollectionDetailsCellViewModel? {
            didSet {
                guard let viewModel else { return }
                name.text = viewModel.name
                price.text = "\(viewModel.price) ETH"
                viewModel.downloadImageFor(nftImageView)
                ratingStackView = viewModel.getImageForRating()
                
                viewModel.$isInCart.bind(action: { [weak self] check in
                    CustomProgressHUD.dismiss()
                    _ = check ? self?.setInCart() : self?.setOutCart()
                })
                
                viewModel.$isFavorite.bind(action: { [weak self] check in
                    CustomProgressHUD.dismiss()
                    _ = check ? self?.setFavorite() : self?.setNotFavorite()
                })
                
                viewModel.$isFailed.bind(action: { check in
                    if check {
                        CustomProgressHUD.dismiss()
                    }
                })
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Asset.Colors.ypWhite.color
        addSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapCart() {
        CustomProgressHUD.show()
        viewModel?.didTapCart()
    }
    
    @objc
    private func didTapFavorite() {
        CustomProgressHUD.show()
        viewModel?.didTapFavorite()
    }
    
    private func setInCart() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.cartButton.alpha = 0
            self?.cartButton.setImage(Consts.Images.inCart, for: .normal)
        } completion: { [weak self] isCompleted in
            if isCompleted {
                self?.cartButton.alpha = 1
            }
        }
    }
    
    private func setOutCart() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.cartButton.alpha = 0
            self?.cartButton.setImage(Consts.Images.outCart, for: .normal)
        } completion: { [weak self] isCompleted in
            if isCompleted {
                self?.cartButton.alpha = 1
            }
        }
    }
    
    private func setFavorite() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.favoriteButton.setImage(Consts.Images.inFavorites, for: .normal)
            self?.favoriteButton.tintColor = Asset.Colors.ypRedUniversal.color
        }
    }
    
    private func setNotFavorite() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.favoriteButton.setImage(Consts.Images.outFavorites, for: .normal)
            self?.favoriteButton.tintColor = Asset.Colors.ypWhiteUniversal.color
        }
    }
    
    private func setupRatingStackView() {
        guard let ratingStackView else { return }
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStackView)
        
        ratingStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftImageView.snp.bottom).offset(8)
        }
        
    }
    
    private func addSubviews() {
        [name, nftImageView, price, cartButton, favoriteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayouts() {
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(108)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(nftImageView.snp.bottom).offset(25)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        price.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
        
        cartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(nftImageView.snp.bottom).offset(25)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
