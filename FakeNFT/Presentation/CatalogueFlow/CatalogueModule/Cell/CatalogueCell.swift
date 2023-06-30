import UIKit
import SnapKit
import Kingfisher
import Combine

protocol CatalogueCellProtocol {
    var isFailedCancellable: AnyCancellable? { get }
    var viewModel: CatalogueCellViewModelProtocol? { get }
}

final class CatalogueCell: UICollectionViewCell, ReuseIdentifying {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = Asset.Colors.ypWhite.color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
    private(set) var isFailedCancellable: AnyCancellable?
    var viewModel: CatalogueCellViewModelProtocol? {
        didSet {
            isFailedCancellable = viewModel?.isFailedPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] check in
                    if check {
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
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
