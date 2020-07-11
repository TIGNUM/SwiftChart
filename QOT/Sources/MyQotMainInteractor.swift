//
//  MyQotMainInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

final class MyQotMainInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotMainWorker()
    private let presenter: MyQotMainPresenterInterface
    private let router: MyQotMainRouterInterface
//    private var teamHeaderItems = [Team.Item]()
    private var arraySectionMyX: ArraySectionMyX = []
    private var subtitles: [String?] = []
    private var eventType: String?
    private var settingsButtonTitle = ""

    // MARK: - Init
    init(presenter: MyQotMainPresenterInterface, router: MyQotMainRouterInterface) {
        self.presenter = presenter
        self.router = router
        createInitialData()
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotMainInteractorInterface
extension MyQotMainInteractor: MyQotMainInteractorInterface {
    func createMyData(irScore: Int?) -> MyX.Item {
        let subtitle = String(irScore ?? 0) + AppTextService.get(.my_qot_section_my_data_subtitle)
        return worker.getItem(in: .data, subTitle: subtitle)
    }

    func createToBeVision(date: Date?) -> MyX.Item {
        guard date != nil else {
            return worker.getItem(in: .toBeVision)
        }
        let since = Int(timeElapsed(date: date).rounded())
        let key: AppTextKey = since >= 3 ? .my_qot_section_my_tbv_subtitle_more_than : .my_qot_section_my_tbv_subtitle_less_than_3_months
        return worker.getItem(in: .toBeVision, subTitle: AppTextService.get(key))
    }

    func createPreps(dateString: String?, eventType: String?) -> MyX.Item {
        var subtitle = ""
        if let dateString = dateString, let eventType = eventType {
            subtitle = dateString + " " + eventType
        }
        return worker.getItem(in: .preps, subTitle: subtitle)
    }

    func timeElapsed(date: Date?) -> Double {
        if let monthSince = date?.months(to: Date()), monthSince > 1 {
            return Double(monthSince)
        }
        return 0
    }

    func nextPrep(completion: @escaping (String?) -> Void) {
        worker.nextPrep { (preparation) in
            completion(preparation)
        }
    }

    func getCurrentSprintName(completion: @escaping (String?) -> Void) {
        worker.getCurrentSprintName { (sprint) in
            completion(sprint)
        }
    }

    func nextPrepType(completion: @escaping (String?) -> Void) {
        worker.nextPrepType { ( preparation) in
            completion(preparation)
        }
    }

    func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        worker.toBeVisionDate { (toBeVisionDate) in
            completion(toBeVisionDate)
        }
    }
    func updateSelectedTeam(teamId: String) {
//        teamHeaderItems.forEach { $0.selected = (teamId == $0.teamId) }
//        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
    }

    func presentMyProfile() {
        router.presentMyProfile()
    }

    func updateArraySection(_ list: ArraySectionMyX) {
        arraySectionMyX = list
    }

    func getSettingsButtonTitle() -> String {
        return settingsButtonTitle
    }

    func isCellEnabled(for section: MyX.Element?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: worker.canCreateTeam(completion)
        default: completion(true)
        }
    }

    var sectionCount: Int {
        arraySectionMyX.count
    }

    func itemCount(in section: Int) -> Int {
        switch MyX.Section(rawValue: section) {
        case .navigationHeader,
             .teamHeader: return 1
        case .body: return arraySectionMyX.at(index: section)?.elements.count ?? 0
        default: return 0
        }
    }

    func getItem(at indexPath: IndexPath) -> MyX.Item? {
        return arraySectionMyX.at(index: indexPath.section)?.elements.at(index: indexPath.item)
    }

    func getTeamItems() -> [Team.Item] {
        return worker.getTeamItems.teamHeaderItems
    }

    func handleSelection(at indexPath: IndexPath) {
        switch MyX.Section(rawValue: indexPath.section) {
        case .navigationHeader,
             .teamHeader: return
        default:
            switch MyX.Element(rawValue: indexPath.row) {
            case .teamCreate: router.presentEditTeam(.create, team: nil)
            case .library: router.presentMyLibrary()
            case .preps: router.presentMyPreps()
            case .sprints: router.presentMySprints()
            case .data: router.presentMyDataScreen()
            case .toBeVision: router.showTBV()
            default: return
            }
        }
    }
}

extension MyQotMainInteractor {
    func createInitialData() {
        worker.getSubtitles { [weak self] (subtitles) in
            self?.worker.getSettingsTitle { (settingsTitle) in
                guard let strongSelf = self else { return }
                strongSelf.subtitles = subtitles
                strongSelf.settingsButtonTitle = settingsTitle

                var dataList: ArraySectionMyX = [ArraySection(model: .navigationHeader, elements: [])]
                dataList.append(ArraySection(model: .teamHeader, elements: strongSelf.worker.getTeamItems.items))
                dataList.append(ArraySection(model: .body, elements: strongSelf.worker.getBodyElements.items))
                let changeSet = StagedChangeset(source: strongSelf.arraySectionMyX, target: dataList)
                strongSelf.presenter.updateView(changeSet)
            }
        }
    }

    func refreshParams() {
        worker.getImpactReadinessScore { [weak self] (score) in
            self?.worker.toBeVisionDate { (date) in
                self?.worker.nextPrep { (dateString) in
                    self?.worker.nextPrepType { (eventType) in
                        self?.worker.getCurrentSprintName { (sprintName) in
                            guard let strongSelf = self else { return }
                            var bodyItems: [MyX.Item] = []
                            let teamCreateSubtitle = AppTextService.get(.my_x_team_create_description)
                            bodyItems.append(strongSelf.worker.getItem(in: .teamCreate,
                                                                            subTitle: teamCreateSubtitle))
                            bodyItems.append(strongSelf.worker.getItem(in: .library))
                            bodyItems.append(strongSelf.createPreps(dateString: dateString, eventType: eventType))
                            bodyItems.append(strongSelf.worker.getItem(in: .sprints, subTitle: sprintName ?? ""))
                            bodyItems.append(strongSelf.createMyData(irScore: score))
                            bodyItems.append(strongSelf.createToBeVision(date: date))

                            var sections: ArraySectionMyX = [ArraySection(model: .navigationHeader, elements: [])]
                            sections.append(ArraySection(model: .teamHeader, elements: strongSelf.worker.getTeamItems.items))
                            sections.append(ArraySection(model: .body, elements: bodyItems))
                            let changeSet = StagedChangeset(source: strongSelf.arraySectionMyX, target: sections)
                            strongSelf.presenter.updateView(changeSet)
                        }
                    }
                }
            }
        }
    }
}
