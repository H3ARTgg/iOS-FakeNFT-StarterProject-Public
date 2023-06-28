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
        return button
    }()
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold22
        label.text = "Peach"
        return label
    }()
    private lazy var aboutAuthorTextView: UITextView = {
        let textView = UITextView()
        let author = NSMutableAttributedString(string: "John Doe")
        author.addAttributes([.font: Consts.Fonts.regular15, .strokeColor: Asset.Colors.ypBlueUniversal], range: NSRange(location: 0, length: author.length))
        let attributedString = NSMutableAttributedString(string: "Автор коллекции: ")
        attributedString.append(author)
        attributedString.addAttributes([.link: "https://www.vk.com"], range: NSRange(location: 17, length: author.length))
        textView.attributedText = attributedString
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
        textView.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
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

extension CollectionDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionDetailsCell.defaultReuseIdentifier, for: indexPath) as? CollectionDetailsCell else {
            return UICollectionViewCell(frame: .zero)
        }
        return cell
    }
    
}

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
