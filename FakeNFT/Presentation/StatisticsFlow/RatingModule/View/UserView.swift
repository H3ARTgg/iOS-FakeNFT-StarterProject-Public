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
    private lazy var stackView = makeStackView()
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
        bind()
    }
    
    // MARK: - public methods
    func initialize(viewModel: UserViewModelProtocol?) {
        self.viewModel = viewModel
    }
}

private extension UserView {
    private struct ViewConstants {
        static let stackViewHeight: CGFloat = 28
        static let countNFTLabelWidth: CGFloat = 38
        static let edgeDistance: CGFloat = 8
        static let cornerRadius: CGFloat = 12
    }
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.spacing = Consts.Statistic.sideConstant
        return stackView
    }
    
    func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Asset.Assets.noPhoto.image
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = ViewConstants.stackViewHeight / 2
        return imageView
    }
    
    func makeUserNameLabel() -> UILabel {
        let label = makeLabel()
        label.numberOfLines = 0
        return label
    }
    
    func makeCountNFTLabel() -> UILabel {
        let label = makeLabel()
        return label
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Asset.Colors.ypBlack.color
        label.font = UIFont.headline3
        label.textAlignment = .natural
        label.backgroundColor = .clear
        return label
    }
    
    func setupView() {
        backgroundColor = Asset.Colors.ypLightGray.color
        layer.cornerRadius = ViewConstants.cornerRadius
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubview() {
        addSubview(stackView)
        
        [photoImageView, userNameLabel, countNFTLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Consts.Statistic.sideConstant),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Consts.Statistic.sideConstant),
            stackView.heightAnchor.constraint(equalToConstant: ViewConstants.stackViewHeight),

            photoImageView.heightAnchor.constraint(equalToConstant: ViewConstants.stackViewHeight),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),
            
            countNFTLabel.widthAnchor.constraint(equalTo: photoImageView.widthAnchor)
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
