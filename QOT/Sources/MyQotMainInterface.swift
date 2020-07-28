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
    func reload()
    func setupView()
}

protocol MyQotMainPresenterInterface {
    func setupView()
    func updateView(_ differenceList: StagedChangeset<ArraySectionMyX>)
    func reload()
}

protocol MyQotMainInteractorInterface: Interactor {
    var sectionCount: Int { get }
    func updateMyX()

    func getSettingsButtonTitle() -> String
    func getTeamItems() -> [Team.Item]
    func refreshParams()
    func updateArraySection(_ list: ArraySectionMyX)
    func updateSelectedTeam(teamId: String?)
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
    func presentMyLibrary(with team: QDMTeam?)
    func presentMyDataScreen()
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
    func showTBV(team: QDMTeam?)
    func presentTeamPendingInvites(invitations: [QDMTeamInvitation])
}
