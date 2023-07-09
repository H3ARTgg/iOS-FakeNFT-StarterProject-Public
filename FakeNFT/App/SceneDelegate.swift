import UIKit

protocol RouterDelegate: AnyObject {
    func setRootViewController(_ viewController: Presentable?)
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private let coordinatorFactory: CoordinatorsFactoryProtocol = CoordinatorFactory()
    private lazy var router: Routable = Router(routerDelegate: self)
    private lazy var appCoordinator = coordinatorFactory.makeAppCoordinator(router: router)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        appCoordinator.startFlow()
    }
}

// MARK: - Router Delegate

extension SceneDelegate: RouterDelegate {
    func setRootViewController(_ viewController: Presentable?) {
        window?.rootViewController = viewController?.toPresent()
    }
}

extension SceneDelegate: RouterDelegate {
    func setRootViewController(_ viewController: Presentable?) {
        window?.rootViewController = viewController?.toPresent()
    }
}
