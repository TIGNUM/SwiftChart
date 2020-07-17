//
//  MyQotMainInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import DifferenceKit
import qot_dal

protocol MyQotMainViewControllerInterface: class {
    func updateView(_ differenceList: StagedChangeset<ArraySectionMyX>)
    func setupView()
    func updateView()
    func getNavigationHeaderCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell
    func getTeamHeaderCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell
    func getCell(_ collectionView: UICollectionView,
                 _ indexPath: IndexPath,
                 _ myQotItem: MyX.Item?) -> UICollectionViewCell
}

protocol MyQotMainPresenterInterface {
    func setupView()
    func updateView(_ differenceList: StagedChangeset<ArraySectionMyX>)
    func updateView()
}

protocol MyQotMainInteractorInterface: Interactor {
    var sectionCount: Int { get }
    func getSettingsButtonTitle() -> String
    func getTeamItems() -> [Team.Item]
    func refreshParams()
    func updateArraySection(_ list: ArraySectionMyX)
    func updateSelectedTeam(teamId: String)
    func isCellEnabled(for section: MyX.Element?, _ completion: @escaping (Bool) -> Void)
    func itemCount(in section: Int) -> Int
    func getItem(at indexPath: IndexPath) -> MyX.Item?
    func presentMyProfile()
    func handleSelection(at indexPath: IndexPath)
    func presentTeamPendingInvites()
}

protocol MyQotMainRouterInterface {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyLibrary()
    func presentMyDataScreen()
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
    func showTBV(team: QDMTeam?)
    func presentTeamPendingInvites()
}
