import UIKit
import SnapKit

final class CatalogueSupplementaryView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .bodyBold
        title.textColor = Asset.Colors.ypBlack.color
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    var viewModel: CatalogueSupplementaryViewModel? {
        didSet {
            titleLabel.text = viewModel?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16).priority(999)
            make.trailing.equalToSuperview().offset(-16).priority(999)
            make.top.equalToSuperview().offset(4).priority(999)
            make.bottom.equalToSuperview().offset(-21).priority(999)
        }
    }
}
