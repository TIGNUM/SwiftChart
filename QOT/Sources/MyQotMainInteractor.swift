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
    private var eventType: String?

    internal var headerItems = [Team.Item]()
    internal var subtitles = [String: String?]() // [MyX.Item.rawValue: subtitle string]
    internal var hasOwnerEmptyTeamTBV = false
    internal var isCellEnabled = [String: Bool]() // [MyX.Item.rawValue: cell enabled]
    internal var settingTitle: String = ""
    internal var newLibraryItemCount: Int = 0

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

    func loadAllData(_ completion: @escaping () -> Void) {
        newLibraryItemCount = 0
        let dispatchGroup = DispatchGroup()
        // load header items
        dispatchGroup.enter()
        getTeamHeaderItems(showNewRedDot: true) { [weak self] (items) in
            self?.headerItems = items
            self?.selectedTeamItem = items.filter { $0.isSelected }.first
            dispatchGroup.leave()
        }
        // load setting title
        dispatchGroup.enter()
        getSettingsTitle { [weak self] title in
            self?.settingTitle = title
            dispatchGroup.leave()
        }

        for item in MyX.Item.allCases {
            dispatchGroup.enter()
            // load all "isCellEnabled"
            isCellEnabled(for: item) { [weak self] enabled in
                self?.isCellEnabled[item.rawValue] = enabled
                dispatchGroup.leave()
            }

            // load all subtitles
            dispatchGroup.enter()
            switch item {
            case .library:
                dispatchGroup.enter()
                getTeamLibrarySubtitleAndCount(team: selectedTeamItem?.qdmTeam) { [weak self] (subtitle, newItemCount) in
                    self?.subtitles[MyX.Item.library.rawValue] = subtitle
                    // load new item counts
                    self?.newLibraryItemCount = newItemCount
                    dispatchGroup.leave()
                }
            case .preps:
                dispatchGroup.enter()
                getPreparationSubtitle { [weak self] subtitle in
                    self?.subtitles[MyX.Item.preps.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            case .sprints:
                dispatchGroup.enter()
                getCurrentSprintName { [weak self] subtitle in
                    self?.subtitles[MyX.Item.sprints.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            case .data:
                dispatchGroup.enter()
                getMyDataSubtitle { [weak self] subtitle in
                    self?.subtitles[MyX.Item.data.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            case .toBeVision:
                dispatchGroup.enter()
                getToBeVisionSubtitle(team: selectedTeamItem?.qdmTeam) { [weak self] subtitle in
                    self?.subtitles[MyX.Item.toBeVision.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            default: break
            }
            dispatchGroup.leave()
        }

        // load hasOwnerEmptyTeamToBeVision
        dispatchGroup.enter()
        hasOwnerEmptyTeamTBV { [weak self] (isEmpty) in
            self?.hasOwnerEmptyTeamTBV = isEmpty
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    func loadAllDataAndReload() {
        loadAllData { [weak self] in
            self?.presenter.reload()
        }
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

    func getTitle(for item: MyX.Item?) -> String? {
        let isTeam = selectedTeamItem != nil
        if item == .toBeVision && isTeam {
            if self.hasOwnerEmptyTeamTBV {
                return AppTextService.get(.myx_team_tbv_empty_subtitle_vision)
            } else {
                return item?.title(isTeam: isTeam)
            }
        }
        return item?.title(isTeam: isTeam)
    }

    func getSubtitle(for item: MyX.Item?) -> (String?, Bool) {
        switch item {
        case .teamCreate:
            return self.isCellEnabled[MyX.Item.teamCreate.rawValue] == true ? (AppTextService.get(.my_x_team_create_subheader), false) : (AppTextService.get(.my_x_team_create_max_team_sutitle), false)
        case .library:
            return (self.subtitles[MyX.Item.library.rawValue] ?? nil, self.newLibraryItemCount != 0)
        default: break
        }
        let subtitle = self.subtitles[item?.rawValue ?? ""] ?? nil
        return(subtitle, false)
    }

    func getSettingsButtonTitle(_ completion: @escaping (String) -> Void) {
        completion(settingTitle)
    }

    func allMainCellReuseIdentifiers() -> [String] {
        var identifiers = [String]()
        identifiers.append(contentsOf: MyX.Item.allCases.compactMap({ "\($0.rawValue)_personal" }))
        identifiers.append(contentsOf: MyX.Item.allCases.compactMap({ "\($0.rawValue)_team" }))
        return identifiers
    }
    func mainCellReuseIdentifier(at indexPath: IndexPath) -> String {
        let item = getItem(at: indexPath)
        return "\(item?.rawValue ?? "\(indexPath)")_\(selectedTeamItem != nil ? "team" : "personal")"
    }

    func updateMainCell(cell: MyQotMainCollectionViewCell, at indexPath: IndexPath) {
        let item = getItem(at: indexPath)
        let title = getTitle(for: item)
        cell.setTitle(title: title)
        cell.setEnabled(self.isCellEnabled[item?.rawValue ?? ""] ?? true, title: title)
        let subtitleResult = getSubtitle(for: item)
        cell.setSubtitle(subtitleResult.0)
        cell.showRedDot(subtitleResult.1)
    }

    func updateTeamHeaderItems(_ completion: @escaping ([Team.Item]) -> Void) {
        getTeamHeaderItems(showNewRedDot: true, completion)
    }

    func isCellEnabled(for section: MyX.Item?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: canCreateTeam(completion)
        case .toBeVision: canSelectTBV(completion)
        default: DispatchQueue.main.async { completion(true) }
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
            loadAllDataAndReload()
            ExtensionsDataManager().update(.teams)
        default: break
        }
    }

    @objc func didUpdateInvitations(_ notification: Notification) {
        loadAllDataAndReload()
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .didSelectTeam, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didSelectTeamInvite, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didFinishSynchronization, object: nil)
        NotificationCenter.default.removeObserver(self, name: .changedInviteStatus, object: nil)
    }

    func viewWillAppear() {
        loadAllDataAndReload()
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
        let teamItem = headerItems.filter { $0.teamId == teamId }.first
        if selectedTeamItem == nil {
            selectedTeamItem = teamItem // select item
            loadAllData { [weak self] in
                self?.presenter.deleteItems(at: MyX.Item.indexPathArrayUpdate(),
                                            updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete(),
                                            originalIndexPathforUpdateIndexPath: MyX.Item.originalIndexPathArrayBeforeDelete())
            }
        } else if selectedTeamItem?.teamId == teamId {
            selectedTeamItem = nil // deselect the item
            loadAllData { [weak self] in
                self?.presenter.inserItems(at: MyX.Item.indexPathArrayUpdate(),
                                           updateIndexPath: MyX.Item.indexPathToUpdateAfterInsert(),
                                           originalIndexPathforUpdateIndexPath: MyX.Item.originalIndexPathArrayBeforeInsert())
            }
        } else { // if selected item is not available any more
            selectedTeamItem = teamItem
            loadAllData { [weak self] in
                self?.presenter.reloadMainItems(updateIndexPath: MyX.Item.indexPathToUpdateAfterDelete())
            }
        }
    }
}
