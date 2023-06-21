import UIKit

final class UserView: UIView {
    
    // MARK: Helpers
    private struct ViewConstants {
        static let imageViewWidth = UIScreen.main.bounds.width / 13.3
        static let countNFTLabelWidth = UIScreen.main.bounds.width / 4
        static let edgeDistance: CGFloat = 8
    }
    
    private var viewModel: UserViewModelProtocol? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - UI
    private lazy var photoImageView = makePhotoImageView()
    private lazy var userNameLabel = makeUserNameLabel()
    private lazy var countNFTLabel = makeCountNFTLabel()
    
    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
        bind()
    }
    
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
    
    // MARK: - public methods
    public func initialize(viewModel: UserViewModelProtocol?) {
        self.viewModel = viewModel
    }
}

extension UserView {
    func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
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
        layer.cornerRadius = 12
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
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Consts.sideConstant),
            photoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.imageViewWidth),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: ViewConstants.edgeDistance),
            userNameLabel.trailingAnchor.constraint(equalTo: countNFTLabel.leadingAnchor),
            
            countNFTLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countNFTLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Consts.sideConstant),
            countNFTLabel.widthAnchor.constraint(equalToConstant: ViewConstants.countNFTLabelWidth)
        ])
    }
    
    func bind() {
        let image = UIImage(named: viewModel?.photo ?? "")
        photoImageView.image = image
        userNameLabel.text = viewModel?.userName
        countNFTLabel.text = String(viewModel?.countNFT ?? 0)
    }
}
