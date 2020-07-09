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
    func setupView()
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
    func updateViewNew(_ differenceList: StagedChangeset<IndexPathArray>)
}

protocol MyQotMainPresenterInterface {
    func setupView()
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
    func updateViewNew(_ differenceList: StagedChangeset<IndexPathArray>)
}

protocol MyQotMainInteractorInterface: Interactor {
    var getViewModel: IndexPathArray { get }
    var sectionCount: Int { get }

    func presentMyProfile()
    func updateViewModelListNew(_ list: IndexPathArray)
    func refreshParams()
    func getSettingsTitle(completion: @escaping (String?) -> Void)
    func updateSelectedTeam(teamId: String)
    func isCellEnabled(for section: MyQotSection?, _ completion: @escaping (Bool) -> Void)
    func itemCount(in section: Int) -> Int
    func getItem(at indexPath: IndexPath) -> MyQot.Item?
    func handleSelection(at indexPath: IndexPath)
}

protocol MyQotMainRouterInterface {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyLibrary()
    func presentMyDataScreen()
    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?)
    func showTBV()
}
