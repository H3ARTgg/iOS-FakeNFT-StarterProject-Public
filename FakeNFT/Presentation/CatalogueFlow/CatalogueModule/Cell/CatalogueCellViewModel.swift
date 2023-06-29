import Kingfisher
import UIKit
import Combine

protocol CatalogueCellViewModelProtocol {
    var isFailedPublisher: AnyPublisher<Bool, Never> { get }
    func downloadImage(for imageView: UIImageView)
}

final class CatalogueCellViewModel: Identifiable, CatalogueCellViewModelProtocol {
    private let imageURL: String
    private let isFailedSubject = CurrentValueSubject<Bool, Never>(false)
    var isFailedPublisher: AnyPublisher<Bool, Never> {
        isFailedSubject.eraseToAnyPublisher()
    }
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    func downloadImage(for imageView: UIImageView) {
        let url = URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let image):
                imageView.image = image.image
                self?.isFailedSubject.send(false)
            case .failure:
                self?.isFailedSubject.send(true)
            }
        }
    }
}
