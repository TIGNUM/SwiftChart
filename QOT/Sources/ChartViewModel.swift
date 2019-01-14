//
//  ChartViewModel.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift
import UIKit

final class ChartViewModel {

    // MARK: - Properties

    static let chartViewPadding: CGFloat = 56
    static let chartCellOffset: CGFloat = 20
    static let chartRatio: CGFloat = 1.3479623824
    let updates = PublishSubject<CollectionUpdate, NoError>()
    private var charts: [[Statistics]] = []
    private let services: Services
    private let permissionsManager: PermissionsManager
    private let syncStateObserver: SyncStateObserver
    var allCharts: [Statistics] = []
    let sortedSections: [StatisticsSectionType] = [.intensity, .meetings, .sleep, .activity]
    var calandarAccessGranted = false

    // MARK: - Init

    init(services: Services, permissionsManager: PermissionsManager, startingSection: StatisticsSectionType) {
        self.services = services
        self.permissionsManager = permissionsManager
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        syncStateObserver.onUpdate { [unowned self] _ in
            do {
                self.charts = try services.statisticsService.charts()
                self.allCharts = self.charts.flatMap { $0 }
                self.askPermissionForCalendar()
                self.updates.next(.reload)
            } catch let error {
                log(error)
            }
        }
    }

    // MARK: - Public

    static func chartCellSize(frameWidth: CGFloat) -> CGSize {
        let width = frameWidth - ChartViewModel.chartViewPadding
        let height = width * ChartViewModel.chartRatio
        return CGSize(width: width, height: height)
    }

    static func leadingOffset(frameWidth: CGFloat) -> CGFloat {
        return (frameWidth - ChartViewModel.chartCellSize(frameWidth: frameWidth).width) * 0.5
    }

    var fitbitState: User.FitbitState {
        return services.userService.fitbitState
    }

    var numberOfSections: Int {
        return sortedSections.count
    }

    func numberOfItems(in section: Int) -> Int {
        return sortedSections[section].chartTypes.count
    }

    func sectionType(in section: Int) -> StatisticsSectionType {
        guard section < sortedSections.count else {
            fatalError("Invalid section type")
        }
        return sortedSections[section]
    }

    func chartTypes(section: Int, item: Int) -> [ChartType] {
        return sectionType(in: section).chartTypes[item]
    }

    func chartType(section: Int, item: Int, buttonTag: Int = 0) -> ChartType {
        return sectionType(in: section).chartTypes[item][buttonTag]
    }

    func statistics(section: Int, item: Int, buttonTag: Int = 0) -> Statistics? {
        let cardType = sectionType(in: section).chartTypes[item][buttonTag]
        return allCharts.filter { $0.key == cardType.rawValue }.first
    }

    func sectionTitle(in section: Int) -> String {
        return sectionType(in: section).title
    }

    func chartTitle(section: Int, item: Int, buttonTag: Int = 0) -> String {
        return sectionType(in: section).chartTypes[item][buttonTag].title
    }

    func userAverage(section: Int, item: Int, buttonTag: Int = 0) -> CGFloat {
        return statistics(section: section, item: item, buttonTag: buttonTag)?.userAverageValue ?? 0
    }

    func teamAverage(section: Int, item: Int, buttonTag: Int = 0) -> CGFloat {
        return statistics(section: section, item: item, buttonTag: buttonTag)?.teamAverageValue ?? 0
    }

    func dataAverage(section: Int, item: Int, buttonTag: Int = 0) -> CGFloat {
        return statistics(section: section, item: item, buttonTag: buttonTag)?.dataAverageValue ?? 0
    }

    func isReady() -> Bool {
        return syncStateObserver.hasSynced(Statistics.self) && allCharts.count > 0
    }
}

// MARK: - Private

private extension ChartViewModel {

    private func askPermissionForCalendar() {
        permissionsManager.askPermission(for: [.calendar]) { status in
            guard let status = status[.calendar] else { return }
            self.calandarAccessGranted = status == .granted
        }
    }
}
