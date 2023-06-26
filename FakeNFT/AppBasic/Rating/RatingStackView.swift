import UIKit

final class RatingStackView: UIStackView {
    
    // MARK: - Properties
    private var stars = [StarImageView]()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .equalSpacing
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 12).isActive = true
        widthAnchor.constraint(equalToConstant: 68).isActive = true
        
        addElements()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupRating(_ rating: Int) {
        stars.forEach { $0.image = Asset.Assets.star.image }
        
        for index in 0..<rating {
            stars[index].image = Asset.Assets.fillStar.image
        }
    }
    
    // MARK: - Private methods
    private func addElements() {
        for _ in 1...5 {
            let star = StarImageView()
            stars.append(star)
        }
        
        stars.forEach { addArrangedSubview($0) }
    }
}
