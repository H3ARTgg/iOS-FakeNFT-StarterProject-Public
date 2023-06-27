import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        guard let window = self.view.window else { return }
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        window.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        guard let window = self.view.window else { return }
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        window.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
