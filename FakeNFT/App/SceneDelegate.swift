import UIKit

protocol RouterDelegate: AnyObject {
    func setRootViewController(_ viewController: Presentable?)
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let mainTabBarController = MainTabBarController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: RouterDelegate {
    func setRootViewController(_ viewController: Presentable?) {
        window?.rootViewController = viewController?.toPresent()
    }
}
