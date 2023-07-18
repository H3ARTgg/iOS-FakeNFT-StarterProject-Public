import UIKit

protocol Routable {
    func setRootViewController(viewController: Presentable)
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, dismissCompletion: (() -> Void)?)
    func present(_ module: Presentable?, animated: Bool)
    func present(_ module: Presentable?, presentationStyle: UIModalPresentationStyle)
    func present(_ module: Presentable?, animated: Bool, presentationStyle: UIModalPresentationStyle, dismissCompletion: (() -> Void)?)
    
    func push(_ module: Presentable?, to navController: UINavigationController)
    func push(_ module: Presentable?, to navController: UINavigationController, animated: Bool)
    
    func pop()
    func pop(animated: Bool)
    func popToRoot(animated: Bool)

    func dismissModule(_ module: Presentable?)
    func dismissModule(_ module: Presentable?, completion: (() -> Void)?)
    func dismissModule(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    
    func presentErrorAlert(message: String, dismissCompletion: (() -> Void)?)
    func presentAlertController(alertModel: AlertModel, preferredStyle: UIAlertController.Style)

    func addToTabBar(_ module: Presentable?)
}

final class Router: NSObject {
    weak var delegate: RouterDelegate?
    private var completions: [UIViewController: (() -> Void)?]
    private var presentingViewController: Presentable?
    
    init(routerDelegate: RouterDelegate) {
        self.delegate = routerDelegate
        self.completions = [:]
    }
}

extension Router: Routable {
    func push(_ module: Presentable?, to navController: UINavigationController) {
        push(module, to: navController, animated: true)
    }

    func push(_ module: Presentable?, to navController: UINavigationController, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        
        guard let tabbarItem = presentingViewController as? UITabBarController else {
            return
        }

        guard
            let tabbarViewControllers = tabbarItem.viewControllers,
            tabbarViewControllers.contains(navController)
        else {
            return
        }
        
        navController.pushViewController(controller, animated: animated)
    }

    func pop() {
        pop(animated: true)
    }

    func pop(animated: Bool) {
        guard let selectedController = presentingViewController as? UITabBarController else {
            return
        }

        guard let rootViewController = selectedController.selectedViewController as? UINavigationController else {
            return
        }

        rootViewController.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool) {
        guard let selectedController = presentingViewController as? UITabBarController else {
            return
        }

        guard let rootViewController = selectedController.selectedViewController as? UINavigationController else {
            return
        }

        rootViewController.popToRootViewController(animated: true)
    }

    func setRootViewController(viewController: Presentable) {
        presentingViewController = viewController
        delegate?.setRootViewController(presentingViewController)
    }
    
    func present(_ module: Presentable?, dismissCompletion: (() -> Void)? = nil) {
        present(module, animated: true, presentationStyle: .automatic, dismissCompletion: dismissCompletion)
    }
    
    func present(_ module: Presentable?) {
        present(module, animated: true, presentationStyle: .automatic)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        present(module, animated: animated, presentationStyle: .automatic)
    }
    
    func present(_ module: Presentable?, presentationStyle: UIModalPresentationStyle) {
        present(module, animated: true, presentationStyle: presentationStyle)
    }
    
    func present(_ module: Presentable?, animated: Bool, presentationStyle: UIModalPresentationStyle, dismissCompletion: (() -> Void)? = nil) {
        guard let controller = module?.toPresent() else { return }
        controller.modalPresentationStyle = presentationStyle
        controller.presentationController?.delegate = self
        presentingViewController?.toPresent()?.present(controller, animated: animated, completion: nil)
        presentingViewController = controller
        addCompletion(dismissCompletion, for: controller)
    }
    
    func dismissModule(_ module: Presentable?) {
        dismissModule(module, animated: true, completion: nil)
    }
    
    func dismissModule(_ module: Presentable?, completion: (() -> Void)?) {
        dismissModule(module, animated: true, completion: completion)
    }
    
    func dismissModule(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent() else { return }
        deleteCompletion(for: presentingViewController?.toPresent())
        self.presentingViewController = module?.toPresent()?.presentingViewController
        controller.dismiss(animated: animated, completion: completion)
    }
    
    func addToTabBar(_ module: Presentable?) {
        guard let controller = module?.toPresent() else { return }
        guard let rootViewController = presentingViewController as? UITabBarController else { return }
        rootViewController.viewControllers?.forEach { tabBarController in
            if tabBarController !== controller { return }
        }
        var viewControllers = rootViewController.viewControllers ?? []
        viewControllers.append(controller)
        rootViewController.setViewControllers(viewControllers, animated: false)
    }
    
    func presentErrorAlert(message: String, dismissCompletion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: L10n.Router.error,
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: L10n.Router.back,
            style: .cancel,
            handler: { _ in
                dismissCompletion?()
            }
        )

        alert.addAction(action)
        self.presentingViewController?
            .toPresent()?
            .present(
                alert,
                animated: true
            )
    }
    
    func presentAlertController(alertModel: AlertModel, preferredStyle: UIAlertController.Style) {
        let alert = UIAlertController(title: alertModel.alertText, message: alertModel.message, preferredStyle: preferredStyle)
        alertModel.alertActions.forEach { alertAction in
            let actionStyle: UIAlertAction.Style
            switch alertAction.actionRole {
            case .destructive: actionStyle = .destructive
            case .regular: actionStyle = .default
            case .cancel: actionStyle = .cancel
            }
            
            let action = UIAlertAction(title: alertAction.actionText, style: actionStyle, handler: { _ in alertAction.action?() })
            alert.addAction(action)
        }
        presentingViewController?.toPresent()?.present(alert, animated: true)
    }
}

extension Router: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presentingViewController = presentationController.presentingViewController
        runCompletion(for: presentationController.presentedViewController)
    }
}

private extension Router {
    func addCompletion(_ completion: (() -> Void)?, for controller: UIViewController?) {
        if let completion, let controller {
            completions[controller] = completion
        }
    }
    
    func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion?()
        completions.removeValue(forKey: controller)
    }
    
    func deleteCompletion(for controller: UIViewController?) {
        guard let controller else { return }
        completions.removeValue(forKey: controller)
    }
}
