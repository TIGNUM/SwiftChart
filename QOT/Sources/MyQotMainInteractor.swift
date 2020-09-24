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
    internal var isCellEnabled = [String: Bool]() // [MyX.Item.rawValue: cell enabled]
    internal var settingTitle: String = ""
    internal var newLibraryItemCount: Int = 0
    internal var tbvTitle: String = ""
    internal var teamTBVPoll: QDMTeamToBeVisionPoll?

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
        let dispatchGroup = DispatchGroup()
        var tmpSelectedTeamItem: Team.Item? = selectedTeamItem
        // load header items
        dispatchGroup.enter()
        var tmpHeaderItems = [Team.Item]()
        getTeamHeaderItems(showNewRedDot: true) { (items) in
            tmpHeaderItems = items
            tmpSelectedTeamItem = items.filter { $0.isSelected }.first
            dispatchGroup.leave()
        }

        var tmpNewLibraryItemCount = 0
        var tmpToBeVisionTitle = ""
        var tmpTeamTBVPoll: QDMTeamToBeVisionPoll?
        var tmpSubtitles = [String: String?]()
        var tmpIsCellEnabled = [String: Bool]()

        for item in MyX.Item.allCases {
            dispatchGroup.enter()
            // load all "isCellEnabled"
            isCellEnabled(for: tmpSelectedTeamItem, section: item) { enabled in
                tmpIsCellEnabled[item.rawValue] = enabled
                dispatchGroup.leave()
            }

            // load all subtitles
            switch item {
            case .library:
                dispatchGroup.enter()
                getTeamLibrarySubtitleAndCount(team: tmpSelectedTeamItem?.qdmTeam) { (subtitle, newItemCount) in
                    tmpSubtitles[MyX.Item.library.rawValue] = subtitle
                    // load new item counts
                    tmpNewLibraryItemCount = newItemCount
                    dispatchGroup.leave()
                }
            case .preps:
                dispatchGroup.enter()
                getPreparationSubtitle { subtitle in
                    tmpSubtitles[MyX.Item.preps.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            case .sprints:
                dispatchGroup.enter()
                getCurrentSprintName { subtitle in
                    tmpSubtitles[MyX.Item.sprints.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            case .data:
                dispatchGroup.enter()
                getMyDataSubtitle { subtitle in
                    tmpSubtitles[MyX.Item.data.rawValue] = subtitle
                    dispatchGroup.leave()
                }
            case .toBeVision:
                dispatchGroup.enter()
                getToBeVisionSubtitle(team: tmpSelectedTeamItem?.qdmTeam) { subtitle in
                    tmpSubtitles[MyX.Item.toBeVision.rawValue] = subtitle
                    dispatchGroup.leave()
                }

                dispatchGroup.enter()
                getToBeVisionData(item: .toBeVision, teamItem: tmpSelectedTeamItem) { (title, poll) in
                    tmpToBeVisionTitle = title
                    tmpTeamTBVPoll = poll
                    dispatchGroup.leave()
                }
            default: break
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.headerItems = tmpHeaderItems
            self?.selectedTeamItem = tmpSelectedTeamItem
            self?.newLibraryItemCount = tmpNewLibraryItemCount
            self?.subtitles = tmpSubtitles
            self?.isCellEnabled = tmpIsCellEnabled
            self?.tbvTitle = tmpToBeVisionTitle
            self?.teamTBVPoll = tmpTeamTBVPoll
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
        if item == .toBeVision && selectedTeamItem != nil {
            return tbvTitle
        }
        return item?.title(isTeam: false, isPollInProgress: false)
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
        getSettingsTitle { [weak self] title in
            self?.settingTitle = title
            completion(title)
        }
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

    func isCellEnabled(for teamItem: Team.Item?, section: MyX.Item?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: canCreateTeam(completion)
        case .toBeVision: canSelectTBV(for: teamItem, completion)
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
            let team = selectedTeamItem?.qdmTeam

            if teamTBVPoll == nil && team == nil {
                router.showTBV()
            }

            if let team = team {
                if let poll = teamTBVPoll, poll.open {
                    if poll.creator {
                        router.showTeamTBVOptions(poll: poll,
                                                  type: .voting,
                                                  remainingDays: Date().days(to: poll.endDate ?? Date()))
                    } else if poll.userDidVote {
                        //TODO: Show banner -> Poll ends in x days
                    } else {
                        router.showTeamTBV(team, poll)
                    }
                } else {
                    router.showTeamTBV(team, teamTBVPoll)
                }
            }
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
    func canSelectTBV(for teamItem: Team.Item?, _ completion: @escaping (Bool) -> Void) {
        guard let team = teamItem?.qdmTeam else {
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
        if selectedTeamItem != nil, teamItem != nil, teamItem?.teamId != selectedTeamItem?.teamId { // changing team
            selectedTeamItem = teamItem
            loadAllData { [weak self] in
                self?.presenter.reload()
            }
            return
        } else if selectedTeamItem != nil, teamItem != nil, teamItem?.teamId == selectedTeamItem?.teamId { // delselect team
            selectedTeamItem = nil
        } else if selectedTeamItem == nil, teamItem != nil { // select team
            selectedTeamItem = teamItem // select item
        } else { // if selected item is not available any more
            selectedTeamItem = nil
            loadAllData { [weak self] in
                self?.presenter.reload()
            }
            return
        }
        loadAllData { [weak self] in
            let personalPrefixes: [String] = MyX.Item.allCases.compactMap({ $0.rawValue })
            let teamPrefixes: [String] = [MyX.Item.library.rawValue, MyX.Item.toBeVision.rawValue]
            self?.presenter.presentItemsWith(identifiers: self?.selectedTeamItem == nil ? personalPrefixes : teamPrefixes,
                                             maxCount: MyX.Item.allCases.count)
        }
    }
}
