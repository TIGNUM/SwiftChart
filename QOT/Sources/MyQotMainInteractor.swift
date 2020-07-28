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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
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

    func clearTeamItems() {
        NotificationCenter.default.post(name: .didSelectTeam,
                                        object: nil,
                                        userInfo: [Team.KeyTeamId: selectdTeamId ?? ""])
        teamHeaderItems.removeAll()
        selectdTeamId = nil
    }

    func updateTeamHeaderItems(_ completion: @escaping ([Team.Item]) -> Void) {
        if teamHeaderItems.isEmpty {
            getTeamHeaderItems { (items) in
                self.teamHeaderItems = items
                completion(items)
            }
        } else {
            completion(teamHeaderItems)
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
            presenter.deleteItems(at: MyX.Item.indexPathUpdate())
        } else if selectdTeamId == teamId {
            selectdTeamId = nil
            presenter.inserItems(at: MyX.Item.indexPathUpdate())
        } else {
            selectdTeamId = teamId
        }
    }

    func presentMyProfile() {
        clearTeamItems()
        router.presentMyProfile()
    }

    func getSettingsButtonTitle(_ completion: @escaping (String) -> Void) {
        getSettingsTitle(completion)
    }

    func isCellEnabled(for section: MyX.Item?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: canCreateTeam(completion)
        case .toBeVision: isTbvEmpty(completion)
        default: completion(true)
        }
    }

    func getItem(at indexPath: IndexPath) -> MyX.Item? {
        return MyX.Item.items(selectdTeamId != nil).at(index: indexPath.row)
    }

    func presentTeamPendingInvites() {
        if let invites = teamHeaderItems.first?.invites, !invites.isEmpty {
            clearTeamItems()
            router.presentTeamPendingInvites(invitations: invites)
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
}

extension MyQotMainInteractor {
//    func updateMyXElements() {
//        worker.getBodyElements(isTeam: self.currentTeam != nil) { (bodyElements) in
//            self.bodyElements = bodyElements
//        }
//    }
//
//    func updateTeamHeaderItems(_ completion: @escaping ([Team.Item]) -> Void) {
//        worker.getTeamHeaderItems { [weak self] (teamItems) in
//            self?.teamHeaderItems = teamItems
//            completion(teamItems)
//        }
//    }

//    func createInitialData() {
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        worker.getSubtitles { [weak self] (subtitles) in
//            self?.subtitles = subtitles
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .main) { [weak self] in
//            guard let strongSelf = self else { return }
//            let dataList: ArraySectionMyX = [ArraySection(model: .body, elements: strongSelf.bodyElements.items)]
////            dataList.append(ArraySection(model: .teamHeader, elements: strongSelf.teamElements.items))
////            dataList.append(ArraySection(model: .body, elements: strongSelf.bodyElements.items))
//            let changeSet = StagedChangeset(source: strongSelf.arraySectionMyX, target: dataList)
////            strongSelf.presenter.updateView(changeSet)
//            strongSelf.presenter.reload()
//        }
//    }

//    func refreshParams() {
//        if currentTeam == nil {
//            getPersonalParams()
//        } else {
//            getTeamParams()
//        }
//    }

//    private func getTeamParams() {
//        var visionDate: Date?
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        worker.toBeVisionDate { (date) in
//            visionDate = date
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .main) { [weak self] in
//            guard let strongSelf = self else { return }
//            var bodyItems: [MyX.Item] = []
//
//            if let libraryItem = strongSelf.getItem(in: .library),
//                let visionItem = strongSelf.createToBeVision(date: visionDate) {
//                bodyItems.append(libraryItem)
//                bodyItems.append(visionItem)
//
//                ArraySection(model: <#T##_#>, elements: <#T##Collection#>)
//                let sections: ArraySectionMyX = [ArraySection(model: .body, elements: bodyItems)]
////                sections.append(ArraySection(model: .teamHeader, elements: []))
////                sections.append(ArraySection(model: .body, elements: bodyItems))
//                let changeSet = StagedChangeset(source: strongSelf.arraySectionMyX, target: sections)
////                strongSelf.presenter.updateView(changeSet)
//                strongSelf.presenter.reload()
//            }
//        }
//    }

//    private func getPersonalParams() {
//        var readinessScore = 0
//        var visionDate: Date?
//        var nextPrepDateString: String?
//        var nextPrepType: String?
//        var currentSprintName: String?
//
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        worker.getImpactReadinessScore { (score) in
//            readinessScore = score ?? 0
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        worker.toBeVisionDate { (date) in
//            visionDate = date
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        worker.nextPrep { (dateString) in
//            nextPrepDateString = dateString
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        worker.nextPrepType { (eventType) in
//            nextPrepType = eventType
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        worker.getCurrentSprintName { (sprintName) in
//            currentSprintName = sprintName
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .main) {  [weak self] in
//            guard let strongSelf = self else { return }
//            var bodyItems: [MyX.Item] = []
//            let teamCreateSubtitle = AppTextService.get(.my_x_team_create_description)
//
//            if let teamItem = strongSelf.getItem(in: .teamCreate, subTitle: teamCreateSubtitle),
//                let libraryItem = strongSelf.getItem(in: .library),
//                let prepItem = strongSelf.createPreps(dateString: nextPrepDateString, eventType: nextPrepType),
//                let sprintItem = strongSelf.getItem(in: .sprints, subTitle: currentSprintName ?? ""),
//                let dataItem = strongSelf.createMyData(irScore: readinessScore),
//                let visionItem = strongSelf.createToBeVision(date: visionDate) {
//
//                bodyItems.append(teamItem)
//                  bodyItems.append(libraryItem)
//                  bodyItems.append(prepItem)
//                  bodyItems.append(sprintItem)
//                  bodyItems.append(dataItem)
//                  bodyItems.append(visionItem)
//
//                  let sections: ArraySectionMyX = [ArraySection(model: .body, elements: bodyItems)]
////                  sections.append(ArraySection(model: .teamHeader, elements: []))
////                  sections.append(ArraySection(model: .body, elements: bodyItems))
//                  let changeSet = StagedChangeset(source: strongSelf.arraySectionMyX, target: sections)
////                  strongSelf.presenter.updateView(changeSet)
//                  strongSelf.presenter.reload()
//            }
//        }
//    }
}
