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
    
    // MARK: - Helpers
    func setupRating(_ rating: Int) {
        for view in subviews {
            if let imageView = view as? UIImageView {
                imageView.image = Asset.Assets.star.image
            }
        }
        
        for index in 0..<rating {
            if let fullStar = subviews[index] as? UIImageView {
                fullStar.image = Asset.Assets.fillStar.image
            }
        }
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
