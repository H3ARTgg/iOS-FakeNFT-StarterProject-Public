import UIKit
import SnapKit

final class CatalogueSupplementaryView: UICollectionReusableView {
    let titleLabel: UILabel = {
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
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top).offset(4)
            make.bottom.equalTo(self.snp.bottom).offset(-21)
        }
    }
}
