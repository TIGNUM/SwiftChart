//
//  MyQotMainInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit

final class MyQotMainInteractor {

    // MARK: - Properties

    private let worker: MyQotMainWorker
    private let presenter: MyQotMainPresenterInterface
    private let router: MyQotMainRouterInterface
    private var viewModelOldListModels: [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>] = []
    private var subtitles: [String?] = []
    private var dateOfPrep: String?
    private var eventType: String?

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
        presenter.setupView()
        createInitialData()
    }

    private func createInitialData() {
        var sectionDataList: [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>] = [ArraySection(model: .header,
                                                                                                         elements: [])]
        var elements: [MyQotViewModel.Item] = []
        for index in 0...5 {
            let section = MyQotSection.init(rawValue: index) ?? .profile
            elements.append(MyQotViewModel.Item(myQotSections: section,
                                                title: worker.myQOTTitle(for: section),
                                                subtitle: nil,
                                                showSubtitleInRed: false))
        }

        sectionDataList.append(ArraySection(model: .body,
                                            elements: elements))

        let changeSet = StagedChangeset(source: self.viewModelOldListModels, target: sectionDataList)
        self.presenter.updateViewNew(changeSet)

    }

    private func createMyData(irScore: Int?) -> [MyQotViewModel.Item] {
        var item = worker.myQotSections().myQotItems[MyQotSection.data.rawValue]
        item.subtitle = String(irScore ?? 0) + R.string.localized.myQotDataImpact()
        return [item]
    }

    private func createToBeVision(date: Date?) -> [MyQotViewModel.Item] {
        var item = worker.myQotSections().myQotItems[MyQotSection.toBeVision.rawValue]
        if date == nil {
            return [item]
        } else {
            let timeSinceMonth = Int(self.timeElapsed(date: date).rounded())
            var subtitleVision: String?
            if timeSinceMonth >= 3 {
                item.showSubtitleInRed = true
                subtitleVision = R.string.localized.myQotVisionMorethan() + String(describing: timeSinceMonth) + R.string.localized.myQotVisionMonthsSince()
            } else {
                subtitleVision = R.string.localized.myQotVisionLessThan()
            }
            item.subtitle = subtitleVision ?? subtitles[MyQotSection.toBeVision.rawValue] ?? ""
            return [item]
        }
    }

    private func createProfile(userName: String?) -> [MyQotViewModel.Item] {
        var item = worker.myQotSections().myQotItems[MyQotSection.profile.rawValue]
        if userName != nil, subtitles.count > MyQotSection.profile.rawValue {
            item.subtitle = "Hello " + (userName ?? "") + ",\n" + (subtitles[MyQotSection.profile.rawValue]?.lowercased() ?? "")
        }
        return [item]
    }

    private func createLibrary() -> [MyQotViewModel.Item] {
        let item = worker.myQotSections().myQotItems[MyQotSection.library.rawValue]
        return [item]
    }

    private func createPreps(dateString: String?, eventType: String?) -> [MyQotViewModel.Item] {
        var item = worker.myQotSections().myQotItems[MyQotSection.preps.rawValue]
        if dateString != nil && eventType != nil {
            item.subtitle = (dateString ?? "") + " " + (eventType ?? "")
        }
        return [item]
    }

    private func createSprints(sprintName: String?) -> [MyQotViewModel.Item] {
        var item = worker.myQotSections().myQotItems[MyQotSection.sprints.rawValue]
        item.subtitle = sprintName?.capitalizingFirstLetter() ?? ""
        return [item]
    }

    private func timeElapsed(date: Date?) -> Double {
        if let monthSince = date?.months(to: Date()), monthSince > 1 {
            return Double(monthSince)
        }
        return 0
    }

    private func nextPrep(completion: @escaping (String?) -> Void) {
        worker.nextPrep { (preparation) in
            completion(preparation)
        }
    }

    private func getCurrentSprintName(completion: @escaping (String?) -> Void) {
        worker.getCurrentSprintName { (sprint) in
            completion(sprint)
        }
    }

    private func nextPrepType(completion: @escaping (String?) -> Void) {
        worker.nextPrepType { ( preparation) in
            completion(preparation)
        }
    }

    private func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        worker.toBeVisionDate { (toBeVisionDate) in
            completion(toBeVisionDate)
        }
    }
    private func getImpactReadinessScore(completion: @escaping(Int?) -> Void) {
        worker.getImpactReadinessScore(completion: completion)
    }

    private func getSubtitles(completion: @escaping ([String?]) -> Void) {
        worker.getSubtitles(completion: completion)
    }

    private func getUserName(completion: @escaping (String?) -> Void) {
        worker.getUserName(completion: completion)
    }
}

// MARK: - MyQotMainInteractorInterface

extension MyQotMainInteractor: MyQotMainInteractorInterface {

    func presentMyPreps() {
        router.presentMyPreps()
    }

    func presentMyProfile() {
        router.presentMyProfile()
    }

    func presentMySprints() {
        router.presentMySprints()
    }

    func presentMyToBeVision() {
        router.presentMyToBeVision()
    }

    func presentMyLibrary() {
        router.presentMyLibrary()
    }

    func presentMyDataScreen() {
        router.presentMyDataScreen()
    }

    func qotViewModelNew() -> [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]? {
        return viewModelOldListModels
    }

    func updateViewModelListNew(_ list: [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]) {
        viewModelOldListModels = list
    }

    func refreshParams() {
        var sectionDataList: [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>] = [ArraySection(model: .header,
                                                                                                         elements: [])]
        var elements: [MyQotViewModel.Item] = []

        getSubtitles(completion: { [weak self] (subtitles) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.subtitles = subtitles
            strongSelf.getImpactReadinessScore(completion: { [weak self] (score) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.toBeVisionDate(completion: { [weak self] (date) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.getUserName(completion: {(name) in
                        strongSelf.nextPrep(completion: { [weak self] (dateString) in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.nextPrepType(completion: { [weak self] (eventType) in
                                guard let strongSelf = self else {
                                    return
                                }
                                strongSelf.getCurrentSprintName(completion: { [weak self] (sprintName) in
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    elements.append(contentsOf: strongSelf.createProfile(userName: name))
                                    elements.append(contentsOf: strongSelf.createLibrary())
                                    elements.append(contentsOf: strongSelf.createPreps(dateString: dateString, eventType: eventType))
                                    elements.append(contentsOf: strongSelf.createSprints(sprintName: sprintName))
                                    elements.append(contentsOf: strongSelf.createMyData(irScore: score))
                                    elements.append(contentsOf: strongSelf.createToBeVision(date: date))

                                    sectionDataList.append(ArraySection(model: .body,
                                                                        elements: elements))

                                    let changeSet = StagedChangeset(source: strongSelf.viewModelOldListModels, target: sectionDataList)
                                    strongSelf.presenter.updateViewNew(changeSet)
                                })
                            })
                        })
                    })
                })
            })
        })
    }
}
