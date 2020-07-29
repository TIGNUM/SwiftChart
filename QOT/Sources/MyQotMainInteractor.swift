//
//  MyQotMainInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotMainInteractor: MyQotMainWorker {

    // MARK: - Properties
    private let presenter: MyQotMainPresenterInterface
    private let router: MyQotMainRouterInterface
    private var teamHeaderItems = [Team.Item]()
    private var subtitles: [String?] = []
    private var eventType: String?
    private var selectdTeamId: String?

    // MARK: - Init
    init(presenter: MyQotMainPresenterInterface, router: MyQotMainRouterInterface) {
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotMainInteractorInterface
extension MyQotMainInteractor: MyQotMainInteractorInterface {
    var sectionCount: Int {
        return MyX.Section.allCases.count
    }

    func itemCount(in section: Int) -> Int {
        return MyX.Section.allCases[section].itemCount(selectdTeamId != nil)
    }

    func getItem(at indexPath: IndexPath) -> MyX.Item? {
        return MyX.Item.items(selectdTeamId != nil).at(index: indexPath.row)
    }

    func getTitle(for item: MyX.Item?) -> String? {
        return item?.title(isTeam: selectdTeamId != nil)
    }

    func getSubtitle(for item: MyX.Item?, _ completion: @escaping (String?) -> Void) {
        switch item {
        case .teamCreate:
            completion(AppTextService.get(.my_x_team_create_header))
        case .library:
            completion("")
        case .preps:
           getPreparationSubtitle(completion)
        case .sprints:
            getCurrentSprintName(completion)
        case .data:
            getMyDataSubtitle(completion)
        case .toBeVision:
            getToBeVisionSubtitle(teamId: selectdTeamId, completion)
        default:
            return
        }
    }

    func getSettingsButtonTitle(_ completion: @escaping (String) -> Void) {
        getSettingsTitle(completion)
    }

    func updateTeamHeaderItems(_ completion: @escaping ([Team.Item]) -> Void) {
        if teamHeaderItems.isEmpty {
            getTeamHeaderItems(showInvites: true) { (items) in
                self.teamHeaderItems = items
                completion(items)
            }
        } else {
            completion(teamHeaderItems)
        }
    }

    func isCellEnabled(for section: MyX.Item?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: canCreateTeam(completion)
        case .toBeVision: isTbvEmpty(completion)
        default: completion(true)
        }
    }

    func handleSelection(at indexPath: IndexPath) {
        switch MyX.Item.items(selectdTeamId != nil).at(index: indexPath.row) {
        case .teamCreate:
            clearTeamItems()
            router.presentEditTeam(.create, team: nil)
        case .library:
            getSelectedTeam(teamId: selectdTeamId) { [weak self] (team) in
                self?.router.presentMyLibrary(with: team)
            }
        case .preps:
            router.presentMyPreps()
        case .sprints:
            router.presentMySprints()
        case .data:
            router.presentMyDataScreen()
        case .toBeVision:
            getSelectedTeam(teamId: selectdTeamId) { [weak self] (team) in
                self?.router.showTBV(team: team)
            }
        default: return
        }
    }

    func presentTeamPendingInvites() {
        if let invites = teamHeaderItems.first?.invites, !invites.isEmpty {
            clearTeamItems()
            router.presentTeamPendingInvites(invitations: invites)
        }
    }

    func presentMyProfile() {
        clearTeamItems()
        router.presentMyProfile()
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .didSelectTeam, object: nil)
    }
}

// MARK: - Private
private extension MyQotMainInteractor {
    func isTbvEmpty(_ completion: @escaping (Bool) -> Void) {
        guard let teamId = selectdTeamId else {
            completion(true)
            return
        }

        getSelectedTeam(teamId: teamId) { [weak self] (team) in
            if let team = team, !team.thisUserIsOwner {
                self?.getTeamToBeVision(for: team) { (teamVision) in
                    completion(teamVision != nil)
                }
            } else {
                completion(true)
            }
        }
    }

    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            updateSelectedTeam(teamId: teamId)
        }
    }

    func updateSelectedTeam(teamId: String) {
        teamHeaderItems.forEach { (item) in
            item.selected = teamId == item.teamId && !item.selected
        }

        if selectdTeamId == nil {
            selectdTeamId = teamId
            presenter.deleteItems(at: MyX.Item.indexPathArrayUpdate(),
                                  updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
        } else if selectdTeamId == teamId {
            selectdTeamId = nil
            presenter.inserItems(at: MyX.Item.indexPathArrayUpdate(),
                                 updateIndexPath: MyX.Item.indexPathToUpdateAfterInsert())
        } else {
            selectdTeamId = teamId
            presenter.reloadMainItems(updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
        }
    }

    func clearTeamItems() {
        NotificationCenter.default.post(name: .didSelectTeam,
                                        object: nil,
                                        userInfo: [Team.KeyTeamId: selectdTeamId ?? ""])
        teamHeaderItems.removeAll()
        selectdTeamId = nil
    }
}
