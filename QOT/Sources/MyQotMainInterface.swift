//
//  MyQotMainInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyQotMainViewControllerInterface: class {
    func setupView()
    func reload()
}

protocol MyQotMainPresenterInterface {
    func setupView()
    func reload()
}

protocol MyQotMainInteractorInterface: Interactor {
    var sectionCount: Int { get }
    func itemCount(in section: Int) -> Int

    func getSettingsButtonTitle(_ completion: @escaping (String) -> Void)
    func clearTeamItems()
    func updateSelectedTeam(teamId: String)
    func updateTeamHeaderItems(_ completion: @escaping ([Team.Item]) -> Void)
    func isCellEnabled(for section: MyX.Item?, _ completion: @escaping (Bool) -> Void)
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
