import UIKit

final class CollectionDetailsViewController: UIViewController {
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton.systemButton(with: Consts.Images.backArrow, target: self, action: #selector(didTapBackButton))
        button.tintColor = Asset.Colors.ypBlack.color
        return button
    }()
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        return label
    }()
    private lazy var aboutAuthorTextView: UITextView = {
        let textView = UITextView()
        textView.font = Consts.Fonts.regular13
        textView.textColor = Asset.Colors.ypBlack.color
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = Asset.Colors.ypBlack.color
        textView.font = Consts.Fonts.regular13
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
    var viewModel: CollectionDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.ypWhite.color
        addSubviews()
        setupLayouts()
        
        viewModel?.$nftCollection.bind(action: { [weak self] collection in
            guard let collection else { return }
            guard let self else { return }
            
            self.collectionLabel.text = collection.name
            self.descriptionTextView.text = collection.description
            self.aboutAuthorTextView.attributedText = self.makeTextForAboutAuthor(author: collection.author)
            self.viewModel?.downloadImageFor(self.coverImageView)
        })
        
        viewModel?.$nfts.bind(action: { [weak self] _ in
            self?.collectionView.performBatchUpdates({
                self?.collectionView.insertItems(at: [IndexPath(row: (self?.viewModel?.nfts.count ?? 0) - 1, section: 0)])
            })
        })
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
    
    private func presentNftViewViewController() {
        // *показывает экран просмотра NFT*
    }
    
    private func makeTextForAboutAuthor(author: String) -> NSAttributedString {
        let author = NSMutableAttributedString(string: author)
        author.addAttributes([.font: Consts.Fonts.regular15, .strokeColor: Asset.Colors.ypBlueUniversal], range: NSRange(location: 0, length: author.length))
        let attributedString = NSMutableAttributedString(string: "Автор коллекции: ")
        attributedString.append(author)
        attributedString.addAttributes([.link: "https://practicum.yandex.ru/"], range: NSRange(location: 17, length: author.length))
        return attributedString
    }
}

// MARK: - DataSource
extension CollectionDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.nfts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionDetailsCell.defaultReuseIdentifier, for: indexPath) as? CollectionDetailsCell else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.viewModel = viewModel?.getViewModelForCellAt(indexPath)
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
        presentNftViewViewController()
    }
}

// MARK: - Views
extension CollectionDetailsViewController {
    private func addSubviews() {
        [coverImageView, backButton, collectionLabel, aboutAuthorTextView, descriptionTextView, collectionView].forEach {
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
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(9)
            make.leading.equalToSuperview().offset(9)
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
        UIApplication.shared.canOpenURL(URL)
        return false
    }
}
