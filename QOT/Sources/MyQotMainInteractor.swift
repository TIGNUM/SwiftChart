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
    private var selectedTeamItem: Team.Item?
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
        return MyX.Section.allCases[section].itemCount(selectedTeamItem != nil)
    }

    func getItem(at indexPath: IndexPath) -> MyX.Item? {
        return MyX.Item.items(selectedTeamItem != nil).at(index: indexPath.row)
    }

    func getTitle(for item: MyX.Item?, _ completion: @escaping (String?) -> Void) {
        let isTeam = selectedTeamItem != nil
        if item == .toBeVision && isTeam {
            hasOwnerEmptyTeamTBV { (isEmpty) in
                if isEmpty {
                    completion(AppTextService.get(.myx_team_tbv_empty_subtitle_vision))
                } else {
                    completion(item?.title(isTeam: isTeam))
                }
            }
        } else {
            completion(item?.title(isTeam: isTeam))
        }
    }

    func getSubtitle(for item: MyX.Item?, _ completion: @escaping (String?, Bool) -> Void) {
        switch item {
        case .teamCreate:
            isCellEnabled(for: item) { (enabled) in
                enabled ? completion(AppTextService.get(.my_x_team_create_subheader), false) : completion(AppTextService.get(.my_x_team_create_max_team_sutitle), false)
            }
        case .library:
            getTeamLibrarySubtitleAndCount(team: selectedTeamItem?.qdmTeam) { (subtitle, newItemCount) in
                completion(subtitle, newItemCount != 0)
            }
        case .preps:
            getPreparationSubtitle { subtitle in
                completion(subtitle, false)
            }
        case .sprints:
            getCurrentSprintName { subtitle in
                completion(subtitle, false)
            }
        case .data:
            getMyDataSubtitle { subtitle in
                completion(subtitle, false)
            }
        case .toBeVision:
            getToBeVisionSubtitle(team: selectedTeamItem?.qdmTeam) { subtitle in
                completion(subtitle, false)
            }
        default:
            DispatchQueue.main.async {
                completion(nil, false)
            }
        }
    }

    func getSettingsButtonTitle(_ completion: @escaping (String) -> Void) {
        getSettingsTitle(completion)
    }

    func updateMainCell(cell: MyQotMainCollectionViewCell, at indexPath: IndexPath) {
        let item = getItem(at: indexPath)
        getTitle(for: item) { title in
            cell.setTitle(title: title)
            self.isCellEnabled(for: item) { enabled in
                cell.setEnabled(enabled, title: title)
            }
        }
        getSubtitle(for: item) { (subtitle, hasNewItems) in
            cell.setSubtitle(subtitle)
            cell.showRedDot(hasNewItems)
        }
    }

    func updateTeamHeaderItems(_ completion: @escaping ([Team.Item]) -> Void) {
        getTeamHeaderItems(showNewRedDot: true, completion)
    }

    func isCellEnabled(for section: MyX.Item?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: canCreateTeam(completion)
        case .toBeVision: canSelectTBV(completion)
        default: completion(true)
        }
    }

    func handleSelection(at indexPath: IndexPath) {
        switch MyX.Item.items(selectedTeamItem != nil).at(index: indexPath.row) {
        case .teamCreate:
            router.presentEditTeam(.create, team: nil)
        case .library:
            router.presentMyLibrary(with: selectedTeamItem?.qdmTeam)
        case .preps:
            router.presentMyPreps()
        case .sprints:
            router.presentMySprints()
        case .data:
            router.presentMyDataScreen()
        case .toBeVision:
            router.showTBV(team: selectedTeamItem?.qdmTeam)
        default: return
        }
    }

    @objc func presentTeamPendingInvites() {
        router.presentTeamPendingInvites()
    }

    func presentMyProfile() {
        router.presentMyProfile()
    }

    func addObserver() {
        removeObserver()
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateInvitations(_:)),
                                               name: .changedInviteStatus, object: nil)
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

    @objc func didUpdateInvitations(_ notification: Notification) {
        updateTeamHeaderItems {(items) in
            self.presenter.reload()
        }
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .didSelectTeam, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didSelectTeamInvite, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didFinishSynchronization, object: nil)
        NotificationCenter.default.removeObserver(self, name: .changedInviteStatus, object: nil)
    }

    func viewWillAppear() {
        getTeamHeaderItems(showNewRedDot: true) { [weak self] (items) in
            self?.selectedTeamItem = items.filter { $0.isSelected }.first
            self?.presenter.reload()
        }
    }
}

// MARK: - Private
private extension MyQotMainInteractor {
    func canSelectTBV(_ completion: @escaping (Bool) -> Void) {
        guard let team = selectedTeamItem?.qdmTeam else {
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

    func hasOwnerEmptyTeamTBV(_ completion: @escaping (Bool) -> Void) {
        if selectedTeamItem?.thisUserIsOwner == true, let team = selectedTeamItem?.qdmTeam {
            getTeamToBeVision(for: team) { (teamVision) in
                completion(teamVision == nil)
            }
        } else {
            completion(false)
        }
    }

    @objc func checkSelection(_ notification: Notification) {
        let controller = AppDelegate.topViewController()?.QOTVisibleViewController() as? CoachCollectionViewController
        if controller?.getCurrentPage() == .myX {
            guard let userInfo = notification.userInfo as? [String: String] else { return }
            if let teamId = userInfo[Team.KeyTeamId] {
                log("teamId: " + teamId, level: .debug)
                updateSelectedTeam(teamId: teamId)
            }
        }
    }

    func updateSelectedTeam(teamId: String) {
        getTeamHeaderItems(showNewRedDot: true) { [weak self] (items) in
            let teamItem = items.filter { $0.teamId == teamId }.first
            if self?.selectedTeamItem == nil {
                self?.selectedTeamItem = teamItem
                self?.presenter.deleteItems(at: MyX.Item.indexPathArrayUpdate(),
                                            updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
            } else if self?.selectedTeamItem?.teamId == teamId {
                self?.selectedTeamItem = nil
                self?.presenter.inserItems(at: MyX.Item.indexPathArrayUpdate(),
                                           updateIndexPath: MyX.Item.indexPathToUpdateAfterInsert())
            } else {
                self?.selectedTeamItem = teamItem
                self?.presenter.reloadMainItems(updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
            }
        }
    }
}
