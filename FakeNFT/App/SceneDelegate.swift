import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let mainTabBarController = MainTabBarController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewModel = UserCollectionViewModel(nfts: nil)
        window?.rootViewController = UserCollectionViewController(viewModel: viewModel)
        window?.makeKeyAndVisible()
    }
}
