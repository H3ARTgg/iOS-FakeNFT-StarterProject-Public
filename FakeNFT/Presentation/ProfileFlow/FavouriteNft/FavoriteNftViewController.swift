//
//  FavoriteNftViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 06.07.2023.
//

import UIKit
import Combine

final class FavoriteNftViewController: UIViewController {
    private let viewModel: FavoriteNftViewModelProtocol & CollectionViewModelProtocol
    
    private lazy var dataSource = FavoriteNftDataSource(nftsCollectionView, viewModel: viewModel)
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var nftsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collection.register(FavoriteNftCollectionViewCell.self,
                            forCellWithReuseIdentifier: FavoriteNftCollectionViewCell.identifier)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var noNftsLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.bold17
        label.text = Consts.LocalizedStrings.profileYouHaveNotAnyFavoriteNfts
        label.textColor = Asset.Colors.ypBlack.color
        label.isHidden = true
        return label
    }()
    
    init(viewModel: FavoriteNftViewModelProtocol & CollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addSubviews()
        configure()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nftsCollectionView.dataSource = dataSource
        setupBindings()
        viewModel.requestNfts()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.backButtonTapped()
    } 
}

private extension FavoriteNftViewController {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(7)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        
        let regularSection = NSCollectionLayoutSection(group: group)
        regularSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: regularSection)
        return layout
        
    }
    
    func setupBindings() {
        viewModel.thereIsNfts
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else {
                    return
                }
                
                if state {
                    self.title = Consts.LocalizedStrings.favoriteNfts
                }
                
                self.nftsCollectionView.isHidden = false
                self.noNftsLabel.isHidden = true
            }
            .store(in: &cancellables)
        
        viewModel.nftsPublisher?
            .sink(
                receiveCompletion: { error in
                    print(error)
                },
                receiveValue: { [weak self] nfts in
                    self?.dataSource.reload(nfts)
                }
            )
            .store(in: &cancellables)
        
        viewModel.showLoading
            .sink { [weak self] isVisible in
                self?.displayLoading(isVisible)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Subviews configure + layout

private extension FavoriteNftViewController {
    func addSubviews() {
        view.addSubview(nftsCollectionView)
        view.addSubview(noNftsLabel)
    }
    
    func configure() {
        view.backgroundColor = Asset.Colors.ypWhite.color
        
        nftsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        noNftsLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func applyLayout() {
        NSLayoutConstraint.activate([
            nftsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            noNftsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noNftsLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
