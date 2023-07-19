import UIKit
import Combine

protocol CollectionDetailsViewControllerProtocol: AnyObject {
    var cancellables: [AnyCancellable] { get }
    var viewModel: CollectionDetailsViewModelProtocol { get }
}

final class CollectionDetailsViewController: UIViewController, CollectionDetailsViewControllerProtocol {
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        return label
    }()
    private lazy var aboutAuthorTextView: UITextView = {
        let textView = UITextView()
        textView.font = Consts.Fonts.regular13
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.backgroundColor = .clear
        return textView
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = Asset.Colors.ypBlack.color
        textView.font = Consts.Fonts.regular13
        textView.backgroundColor = .clear
        return textView
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CollectionDetailsCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Asset.Colors.ypWhite.color
        return collectionView
    }()
    private lazy var gesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .right
        gesture.addTarget(self, action: #selector(didSwipeRight))
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()
    private lazy var errorButton: OtherCustomButton = {
        let button = OtherCustomButton.systemButton(with: UIImage(), target: self, action: #selector(didTapErrorButton))
        button.configure(text: L10n.Error.Try.again)
        return button
    }()
    private let errorTitle = UILabel()
    private(set) var viewModel: CollectionDetailsViewModelProtocol
    private(set) var cancellables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        addSubviews()
        setupLayouts()
        binds()
        CustomProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestCollection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CustomProgressHUD.dismiss()
    }
    
    init(viewModel: CollectionDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didSwipeRight() {
        viewModel.didSwipeRight()
    }
    
    @objc
    private func didTapErrorButton() {
        CustomProgressHUD.show()
        viewModel.requestCollection()
    }
    
    private func configureViewController() {
        (UIApplication.shared.windows.first ?? UIWindow()).isUserInteractionEnabled = true
        view.backgroundColor = Asset.Colors.ypWhite.color
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    private func binds() {
        let nftCollectionCancellable = viewModel.nftCollectionPublisher
            .sink { [weak self] collection in
                guard let self else { return }
                guard !collection.isEmpty else { return }
                self.collectionLabel.text = collection[0].name
                self.descriptionTextView.text = collection[0].description
                self.aboutAuthorTextView.attributedText = self.makeTextForAboutAuthor(author: collection[0].author)
                self.viewModel.downloadImageFor(self.coverImageView)
                CustomProgressHUD.dismiss()
                
                if collection.isEmpty {
                    self.setupErrorContent(with: (self.errorTitle, self.errorButton))
                    CustomProgressHUD.dismiss()
                }
            }
        
        let nftsCancellable = viewModel.nftsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.collectionView.reloadData()
            }
        
        cancellables = [nftCollectionCancellable, nftsCancellable]
    }
    
    private func makeTextForAboutAuthor(author: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(L10n.Collection.author): \(author)")
        attributedString.addAttributes([.foregroundColor: Asset.Colors.ypBlack.color], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([.font: Consts.Fonts.regular15, .foregroundColor: Asset.Colors.ypBlueUniversal.color], range: NSRange(location: 19, length: author.count))
        attributedString.addAttributes([.link: "https://practicum.yandex.ru/"], range: NSRange(location: 19, length: author.count))
        return attributedString
    }
}

// MARK: - DataSource
extension CollectionDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNftsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionDetailsCell.defaultReuseIdentifier, for: indexPath) as? CollectionDetailsCell else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.viewModel = viewModel.getViewModelForCellAt(indexPath)
        return cell
    }
    
}

// MARK: - DelegateFlowLayout
extension CollectionDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width / 3 - 9, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // *показывает экран просмотра NFT*
    }
}

// MARK: - Views
extension CollectionDetailsViewController {
    private func addSubviews() {
        [coverImageView, collectionLabel, aboutAuthorTextView, descriptionTextView, collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayouts() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(310)
        }
        
        collectionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
        }
        
        aboutAuthorTextView.snp.makeConstraints { make in
            make.top.equalTo(collectionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(28)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(aboutAuthorTextView.snp.bottom)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: = TextViewDelegate
extension CollectionDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        viewModel.didTapAuthorLink(with: URL)
        return false
    }
}
