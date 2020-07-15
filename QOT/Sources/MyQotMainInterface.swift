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
    func updateView()
    func setupView()
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]>)
}

protocol MyQotMainPresenterInterface {
    func updateView()
    func setupView()
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]>)
}

protocol MyQotMainInteractorInterface: Interactor {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyToBeVision()
    func presentMyLibrary()
    func presentMyDataScreen()
    func presentCreateTeam()
    func qotViewModelNew() -> [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]?
    func updateViewModelListNew(_ list: [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>])
    func refreshParams()
    func getSettingsTitle(completion: @escaping (String?) -> Void)
    func updateSelectedTeam(teamId: String)
    func isCellEnabled(for section: MyQotSection?, _ completion: @escaping (Bool) -> Void)
}

protocol MyQotMainRouterInterface {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyLibrary()
    func presentMyDataScreen()
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
    func showTBV(team: QDMTeam?)
}
