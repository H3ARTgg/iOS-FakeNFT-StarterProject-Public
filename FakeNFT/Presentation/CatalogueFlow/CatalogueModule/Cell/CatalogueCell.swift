import UIKit
import SnapKit
import Kingfisher

final class CatalogueCell: UICollectionViewCell, ReuseIdentifying {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = Asset.Colors.ypWhite.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var failButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: self, action: #selector(didTapFailButton))
        button.setImage(nil, for: .normal)
        button.setTitle(Consts.LocalizedStrings.failImageLoadText, for: .normal)
        button.setTitleColor(Asset.Colors.ypBlack.color, for: .normal)
        button.backgroundColor = Asset.Colors.ypWhite.color
        button.titleLabel?.font = Consts.Fonts.bold22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var viewModel: CatalogueCellViewModel? {
        didSet {
            viewModel?.$isFailed.bind(action: { [weak self] in
                if $0 {
                    self?.setupFailButton()
                } else {
                    self?.removeFailButton()
                }
            })
            viewModel?.downloadImage(for: imageView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    @objc
    private func didTapFailButton() {
        viewModel?.downloadImage(for: imageView)
        removeFailButton()
    }
    
    private func setupFailButton() {
        addSubview(failButton)
        
        failButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func removeFailButton() {
        failButton.removeFromSuperview()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
