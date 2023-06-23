import UIKit

final class CollectionDetailsViewController: UIViewController {
    var viewModel: CollectionDetailsViewModel?
    
    init(viewModel: CollectionDetailsViewModel) {
        super.init(nibName: .none, bundle: .main)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
