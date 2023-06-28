import UIKit

final class CollectionDetailsCell: UICollectionViewCell, ReuseIdentifying {
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Consts.Images.coverFake
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Consts.Images.rating2
        return imageView
    }()
    private lazy var name: UILabel = {
        let label = UILabel()
        label.text = "Archie"
        label.font = Consts.Fonts.bold17
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    private lazy var price: UILabel = {
        let label = UILabel()
        label.text = "1 ETH"
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
        
    }
    
    @objc
    private func didTapFavorite() {
        
    }
    
    private func addSubviews() {
        [name, nftImageView, ratingImageView, price, cartButton, favoriteButton].forEach {
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
        
        ratingImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftImageView.snp.bottom).offset(8)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(ratingImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        price.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
        
        cartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(ratingImageView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
