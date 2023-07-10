import UIKit
import Kingfisher

final class UserView: UIView {
    
    // MARK: - Private properties
    private var viewModel: UserViewModelProtocol? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - UI
    private lazy var photoImageView = makePhotoImageView()
    private lazy var userNameLabel = makeUserNameLabel()
    private lazy var countNFTLabel = makeCountNFTLabel()
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview()
        activateConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
    }
    
    // MARK: - public methods
    func initialize(viewModel: UserViewModelProtocol?) {
        self.viewModel = viewModel
        bind()
    }
}

private extension UserView {
    private struct ViewConstants {
        static let imageViewWidth: CGFloat = 28
        static let countNFTLabelWidth: CGFloat = 38
        static let edgeDistance: CGFloat = 8
        static let cornerRadius: CGFloat = 12
    }
    
    func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.image = Asset.Assets.noPhoto.image
        return imageView
    }
    
    func makeUserNameLabel() -> UILabel {
        let label = makeLabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }
    
    func makeCountNFTLabel() -> UILabel {
        let label = makeLabel()
        label.textAlignment = .right
        return label
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.headline3
        return label
    }
    
    func setupView() {
        backgroundColor = Asset.Colors.ypLightGray.color
        layer.cornerRadius = ViewConstants.cornerRadius
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubview() {
        [photoImageView, userNameLabel, countNFTLabel].forEach {
            addSubview($0)
        }
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Consts.Statistic.sideConstant),
            photoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageViewWidth),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: ViewConstants.edgeDistance),
            userNameLabel.trailingAnchor.constraint(equalTo: countNFTLabel.leadingAnchor),
            
            countNFTLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countNFTLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Consts.Statistic.sideConstant),
            countNFTLabel.widthAnchor.constraint(equalToConstant: ViewConstants.countNFTLabelWidth)
        ])
    }
    
    func bind() {
        userNameLabel.text = viewModel?.userName
        countNFTLabel.text = String(viewModel?.countNFT ?? 0)
        loadImage()
    }
    
    func loadImage() {
        guard let url = viewModel?.avatarURL else { return }
        photoImageView.kf.setImage(with: url)
    }
}
