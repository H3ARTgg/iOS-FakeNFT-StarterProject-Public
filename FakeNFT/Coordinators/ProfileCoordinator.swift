//
//  ProfileCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 09.07.2023.
//

final class ProfileCoordinator: BaseCoordinator, Coordinatable {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: ModulesFactoryProtocol
    private var router: Routable
    private let navController = ProfileNavController()
    
    init(modulesFactory: ModulesFactoryProtocol, router: Routable) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func startFlow() {
        router.addToTabBar(navController)
        performFlow()
    }
}

private extension ProfileCoordinator {
    func performFlow() {
        let profileModule = modulesFactory.makeProfileView()
        let profileView = profileModule.view
        let profileCoordination = profileModule.coordination
        
        profileCoordination.headForEditProfile = { [weak self] profileUser in
            guard let self else {
                return
            }
            
            let profileEditNftsModule = modulesFactory.makeProfileEditView(profileData: profileUser)
            let profileEditView = profileEditNftsModule.view
            var profileEditCoordination = profileEditNftsModule.coordination
            
            profileEditCoordination.finish = { [weak profileCoordination] profileEditUser in
                profileCoordination?.setProfile(profileEditUser)
                self.router.dismissModule(profileEditView)
            }
            
            router.present(profileEditView)
        }
        
        profileCoordination.headForOwnedNfts = { [weak self] ownedNfts in
            guard let self else {
                return
            }
            
            let ownedNftsModule = modulesFactory.makeOwnedNftView(ownedNfts: ownedNfts)
            let ownedNftsView = ownedNftsModule.view
            var ownedNftCoordination = ownedNftsModule.coordination
            
            ownedNftCoordination.headForActionSheet = { alertModel in
                self.router.presentAlertController(alertModel: alertModel, preferredStyle: .actionSheet)
            }
            
            ownedNftCoordination.headForError = { errorMessage in
                self.router.presentErrorAlert(
                    message: errorMessage,
                    dismissCompletion: self.router.pop
                )
            }
            
            router.push(ownedNftsView, to: navController)
        }
        
        profileCoordination.headForFavoriteNfts = { [weak self] favoriteNfts in
            guard let self else {
                return
            }
            
            let favoriteNftsModule = modulesFactory.makeFavoriteNftView(favoriteNfts: favoriteNfts)
            let favoriteNftsView = favoriteNftsModule.view
            var favoriteNftsCoordination = favoriteNftsModule.coordination
            
            favoriteNftsCoordination.finish = { [weak profileCoordination] favoriteNfts in
                profileCoordination?.onReturnFromFavorites()
            }
            
            favoriteNftsCoordination.headForError = { errorMessage in
                self.router.presentErrorAlert(
                    message: errorMessage,
                    dismissCompletion: self.router.pop
                )
            }
            
            router.push(favoriteNftsView, to: navController)
        }
        
        profileCoordination.headForAbout = { [weak self] urlString in
            guard let self else {
                return
            }
            
            let aboutView = modulesFactory.makeAboutWebView(urlString: urlString)
            router.push(aboutView, to: navController)
        }
        
        profileCoordination.headForError = { errorMessage, completion in
            self.router.presentErrorAlert(
                message: errorMessage,
                dismissCompletion: completion
            )
        }
        
        router.push(profileView, to: navController)
    }
}
