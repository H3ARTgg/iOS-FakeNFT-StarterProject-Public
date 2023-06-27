import UIKit

final class CollectionDetailsViewController: UIViewController {
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: Consts.Images.coverFake)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton.systemButton(with: Consts.Images.backArrow, target: self, action: #selector(didTapBackButton))
        button.tintColor = Asset.Colors.ypBlack.color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var viewModel: CollectionDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.ypWhite.color
        addSubviews()
        setupLayout()
    }
    
    init(viewModel: CollectionDetailsViewModel) {
        super.init(nibName: .none, bundle: .main)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapBackButton() {
        dismissDetail()
    }
}

// MARK: - Views
extension CollectionDetailsViewController {
    private func addSubviews() {
        [coverImageView, backButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(310)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(9)
            make.leading.equalToSuperview().offset(9)
        }
    }
}
