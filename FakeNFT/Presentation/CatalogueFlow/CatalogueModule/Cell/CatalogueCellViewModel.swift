import Kingfisher
import UIKit

final class CatalogueCellViewModel: Identifiable {
    private let imageURL: String
    @Observable private(set) var isFailed: Bool = false
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    func downloadImage(for imageView: UIImageView) {
        let url = URL(string: imageURL)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let image):
                imageView.image = image.image
                self?.isFailed = false
            case .failure(_):
                self?.isFailed = true
            }
        }
    }
}
