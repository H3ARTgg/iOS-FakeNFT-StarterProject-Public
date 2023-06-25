//
//  ProfileEditTableView.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 25.06.2023.
//

import UIKit

final class ProfileEditTableView: UITableViewController {
    let profileData = [ProfileTableDataModel(sectionCaption: "Имя", cellText: "Joaquin Phoenix"),
                       ProfileTableDataModel(sectionCaption: "Описание", cellText: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
                       ProfileTableDataModel(sectionCaption: "Сайт", cellText: "Apple")]
    
    private lazy var dataSource = ProfileEditDiffableDataSource(tableView: tableView)
    private lazy var tableHeaderView = ProfileEditTableHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 174))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileEditCell.self,
                           forCellReuseIdentifier: ProfileEditCell.identifier)
        tableView.register(ProfileEditSectionHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ProfileEditSectionHeaderView.identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.closeButtonClosure = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource.reload(profileData)
        tableHeaderView.userPicUrl = URL(string: "https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG")
    }
}

extension ProfileEditTableView {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeaderView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: ProfileEditSectionHeaderView.identifier) as? ProfileEditSectionHeaderView
        else { return UIView() }
        
        sectionHeaderView.headerText = profileData[section].sectionCaption
        return sectionHeaderView
    }
}
