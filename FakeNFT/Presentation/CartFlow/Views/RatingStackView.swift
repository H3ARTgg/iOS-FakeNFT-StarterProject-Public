import UIKit

final class RatingStackView: UIStackView {
    
    // MARK: - Properties
    private let starImageView1 = StarImageView()
    private let starImageView2 = StarImageView()
    private let starImageView3 = StarImageView()
    private let starImageView4 = StarImageView()
    private let starImageView5 = StarImageView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fill
        spacing = 2
        translatesAutoresizingMaskIntoConstraints = false
        
        addElements()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func addElements() {
        [
            starImageView1,
            starImageView2,
            starImageView3,
            starImageView4,
            starImageView5
        ].forEach { addArrangedSubview($0) }
    }
}