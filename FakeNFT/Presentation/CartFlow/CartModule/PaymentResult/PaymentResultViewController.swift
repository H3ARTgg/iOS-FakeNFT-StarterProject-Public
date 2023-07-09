import UIKit

final class PaymentResultViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        let customView = PaymentResultView()
        customView.configure()
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}
