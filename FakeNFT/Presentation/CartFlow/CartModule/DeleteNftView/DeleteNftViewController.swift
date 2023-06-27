import UIKit

protocol DeleteNftViewControllerDelegate: AnyObject {
    func deleteNft()
    func closeViewController()
}

final class DeleteNftViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: CartViewModel
    var nft: Nft?

    // MARK: - Lifecycle
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let customView = DeleteNftView(frame: view.frame)
        customView.configure(delegate: self)
        view = customView
    }
}

// MARK: - DeleteNftViewControllerDelegate
extension DeleteNftViewController: DeleteNftViewControllerDelegate {
    func deleteNft() {
        viewModel.delete(from: nft?.id ?? 0)
        dismiss(animated: true)
    }
    
    func closeViewController() {
        dismiss(animated: true)
    }
}
