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
    private let worker: MyQotMainWorker
    private let presenter: MyQotMainPresenterInterface
    private let router: MyQotMainRouterInterface
    private var teamHeaderItems = [TeamHeader.Item]()
    private var viewModel: IndexPathArray = []
    private var subtitles: [String?] = []
    private var eventType: String?
    private var settingsButtonTitle = ""

    // MARK: - Init
    init(worker: MyQotMainWorker,
         presenter: MyQotMainPresenterInterface,
         router: MyQotMainRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            self?.teamHeaderItems = teamHeaderItems
            self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
        }
        presenter.setupView()
        createInitialData()
    }
}

// MARK: - Private
private extension MyQotMainInteractor {
    func createMyData(irScore: Int?) -> MyQot.Item {
        let subtitle = String(irScore ?? 0) + AppTextService.get(.my_qot_section_my_data_subtitle)
        return worker.getMyQotItem(in: .data, subTitle: subtitle)
    }

    func createToBeVision(date: Date?) -> MyQot.Item {
        guard date != nil else {
            return worker.getMyQotItem(in: .toBeVision)
        }
        let since = Int(timeElapsed(date: date).rounded())
        let key: AppTextKey = since >= 3 ? .my_qot_section_my_tbv_subtitle_more_than : .my_qot_section_my_tbv_subtitle_less_than_3_months
        return worker.getMyQotItem(in: .toBeVision, subTitle: AppTextService.get(key))
    }

    func createPreps(dateString: String?, eventType: String?) -> MyQot.Item {
        var subtitle = ""
        if let dateString = dateString, let eventType = eventType {
            subtitle = dateString + " " + eventType
        }
        return worker.getMyQotItem(in: .preps, subTitle: subtitle)
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
}

// MARK: - MyQotMainInteractorInterface
extension MyQotMainInteractor: MyQotMainInteractorInterface {
    func updateSelectedTeam(teamId: String) {
        teamHeaderItems.forEach { $0.selected = (teamId == $0.teamId) }
        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
    }

    func presentMyProfile() {
        router.presentMyProfile()
    }

    func updateViewModelListNew(_ list: IndexPathArray) {
        viewModel = list
    }

    func getSettingsButtonTitle() -> String {
        return settingsButtonTitle
    }

    func createInitialData() {
        worker.getSubtitles { [weak self] (subtitles) in
            self?.worker.getSettingsTitle { (settingsTitle) in
                guard let strongSelf = self else { return }
                strongSelf.subtitles = subtitles
                strongSelf.settingsButtonTitle = settingsTitle

                let items = MyQotSection.allCases.compactMap { (section) -> MyQot.Item in
                    return MyQot.Item(sections: section,
                                      title: section.title,
                                      subtitle: subtitles.at(index: section.rawValue))
                }

                var sectionDataList: IndexPathArray = [ArraySection(model: .navigationHeader, elements: [])]
                sectionDataList.append(ArraySection(model: .teamHeader, elements: []))
                sectionDataList.append(ArraySection(model: .body, elements: items))
                let changeSet = StagedChangeset(source: strongSelf.viewModel, target: sectionDataList)
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
                            var bodyItems: [MyQot.Item] = []
                            let teamCreateSubtitle = AppTextService.get(.my_x_team_create_description)
                            bodyItems.append(strongSelf.worker.getMyQotItem(in: .teamCreate,
                                                                            subTitle: teamCreateSubtitle))
                            bodyItems.append(strongSelf.worker.getMyQotItem(in: .library))
                            bodyItems.append(strongSelf.createPreps(dateString: dateString, eventType: eventType))
                            bodyItems.append(strongSelf.worker.getMyQotItem(in: .sprints, subTitle: sprintName ?? ""))
                            bodyItems.append(strongSelf.createMyData(irScore: score))
                            bodyItems.append(strongSelf.createToBeVision(date: date))

                            var sections: IndexPathArray = [ArraySection(model: .navigationHeader, elements: [])]
                            sections.append(ArraySection(model: .teamHeader, elements: []))
                            sections.append(ArraySection(model: .body, elements: bodyItems))
                            let changeSet = StagedChangeset(source: strongSelf.viewModel, target: sections)
                            strongSelf.presenter.updateView(changeSet)
                        }
                    }
                }
            }
        }
    }

    func isCellEnabled(for section: MyQotSection?, _ completion: @escaping (Bool) -> Void) {
        switch section {
        case .teamCreate: worker.canCreateTeam(completion)
        default: completion(true)
        }
    }

    var sectionCount: Int {
        viewModel.count
    }

    func itemCount(in section: Int) -> Int {
        switch MyQot.Section(rawValue: section) {
        case .navigationHeader,
             .teamHeader: return 1
        case .body: return viewModel.at(index: section)?.elements.count ?? 0
        default: return 0
        }
    }

    func getItem(at indexPath: IndexPath) -> MyQot.Item? {
        return viewModel.at(index: indexPath.section)?.elements.at(index: indexPath.item)
    }

    func handleSelection(at indexPath: IndexPath) {
        switch MyQot.Section(rawValue: indexPath.section) {
        case .navigationHeader,
             .teamHeader: return
        default:
            switch MyQotSection(rawValue: indexPath.row) {
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
