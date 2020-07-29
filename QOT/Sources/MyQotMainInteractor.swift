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
    private var selectdTeamItem: Team.Item?
    private var subtitles: [String?] = []
    private var eventType: String?

    // MARK: - Init
    init(presenter: MyQotMainPresenterInterface, router: MyQotMainRouterInterface) {
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        ExtensionsDataManager().update(.teams)
    }
}

// MARK: - MyQotMainInteractorInterface
extension MyQotMainInteractor: MyQotMainInteractorInterface {
    var sectionCount: Int {
        return MyX.Section.allCases.count
    }

    func itemCount(in section: Int) -> Int {
        return MyX.Section.allCases[section].itemCount(selectdTeamItem != nil)
    }

    func getItem(at indexPath: IndexPath) -> MyX.Item? {
        return MyX.Item.items(selectdTeamItem != nil).at(index: indexPath.row)
    }

    func getTitle(for item: MyX.Item?) -> String? {
        return item?.title(isTeam: selectdTeamItem != nil)
    }

    func getSubtitle(for item: MyX.Item?, _ completion: @escaping (String?) -> Void) {
        switch item {
        case .teamCreate:
            completion(AppTextService.get(.my_x_team_create_subheader))
        case .library:
            completion("")
        case .preps:
           getPreparationSubtitle(completion)
        case .sprints:
            getCurrentSprintName(completion)
        case .data:
            getMyDataSubtitle(completion)
        case .toBeVision:
            getToBeVisionSubtitle(team: selectdTeamItem?.qdmTeam, completion)
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
        switch MyX.Item.items(selectdTeamItem != nil).at(index: indexPath.row) {
        case .teamCreate:
            clearTeamItems()
            router.presentEditTeam(.create, team: nil)
        case .library:
            router.presentMyLibrary(with: selectdTeamItem?.qdmTeam)
        case .preps:
            router.presentMyPreps()
        case .sprints:
            router.presentMySprints()
        case .data:
            router.presentMyDataScreen()
        case .toBeVision:
            router.showTBV(team: selectdTeamItem?.qdmTeam)
        default: return
        }
    }

    @objc func presentTeamPendingInvites() {
        let teamItems = teamHeaderItems
        clearTeamItems()
        router.presentTeamPendingInvites(teamItems: teamItems)
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentTeamPendingInvites),
                                               name: .didSelectTeamInvite,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateTeamRelatedData(_:)),
                                               name: .didFinishSynchronization, object: nil)
    }

    @objc func didUpdateTeamRelatedData(_ notification: Notification) {
        guard let result = notification.object as? SyncResultContext, result.hasUpdatedContent else { return }
        switch result.dataType {
        case .TEAM:
            presenter.reload()
            ExtensionsDataManager().update(.teams)
        default: break
        }
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .didSelectTeam, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didSelectTeamInvite, object: nil)
    }
}

// MARK: - Private
private extension MyQotMainInteractor {
    func isTbvEmpty(_ completion: @escaping (Bool) -> Void) {
        guard let team = selectdTeamItem?.qdmTeam else {
            completion(true)
            return
        }

        if !team.thisUserIsOwner {
            getTeamToBeVision(for: team) { (teamVision) in
                completion(teamVision != nil)
            }
        } else {
            completion(true)
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

        let teamItem = teamHeaderItems.filter { $0.teamId == teamId }.first
        if selectdTeamItem == nil {
            selectdTeamItem = teamItem
            presenter.deleteItems(at: MyX.Item.indexPathArrayUpdate(),
                                  updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
        } else if selectdTeamItem?.teamId == teamId {
            selectdTeamItem = nil
            presenter.inserItems(at: MyX.Item.indexPathArrayUpdate(),
                                 updateIndexPath: MyX.Item.indexPathToUpdateAfterInsert())
        } else {
            selectdTeamItem = teamItem
            presenter.reloadMainItems(updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
        }
    }

    func clearTeamItems() {
        if selectdTeamItem != nil && selectdTeamItem?.header == .team {
            NotificationCenter.default.post(name: .didSelectTeam,
                                            object: nil,
                                            userInfo: [Team.KeyTeamId: selectdTeamItem?.teamId ?? ""])
        }
        teamHeaderItems.removeAll()
        selectdTeamItem = nil
    }
}
