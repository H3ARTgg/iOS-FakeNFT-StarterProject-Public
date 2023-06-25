import UIKit

final class UserCollectionViewController: UIViewController {
    
    // MARK: private properties
    private let viewModel: UserCollectionViewModelProtocol
    
    // MARK: Initialization
    init(viewModel: UserCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
}

extension UserCollectionViewController {
    func viewSetup() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        navigationController?.title = Consts.LocalizedStrings.userCollectionViewControllerTitle
    }
}
