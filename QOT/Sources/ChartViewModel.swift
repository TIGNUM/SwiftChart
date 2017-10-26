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
    fileprivate let charts: [[Statistics]]
    fileprivate var sortedSections = [StatisticsSectionType]()
    let allCharts: [Statistics]

    // MARK: - Init

    init(services: Services, startingSection: StatisticsSectionType) throws {
        do {
            self.charts = try services.statisticsService.charts()
            self.allCharts = self.charts.flatMap { $0 }
            sortCharts(startingSection: startingSection)
        } catch let error {
            throw error
        }
    }

    // MARK: - Public

    var numberOfSections: Int {
        return sortedSections.count
    }

    func numberOfItems(in section: Int) -> Int {
        return sectionType(in: section).chartTypes.count
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

    func statistics(section: Int, item: Int, buttonTag: Int = 0) -> Statistics {
        let cardType = sectionType(in: section).chartTypes[item][buttonTag]

        return allCharts.filter { $0.key == cardType.rawValue }[0]
    }

    func sectionTitle(in section: Int) -> String {
        return sectionType(in: section).title
    }

    func chartTitle(section: Int, item: Int, buttonTag: Int = 0) -> String {
        return sectionType(in: section).chartTypes[item][buttonTag].title
    }

    func userAverage(section: Int, item: Int, buttonTag: Int = 0) -> CGFloat {
        return statistics(section: section, item: item, buttonTag: buttonTag).userAverageValue
    }

    func teamAverage(section: Int, item: Int, buttonTag: Int = 0) -> CGFloat {
        return statistics(section: section, item: item, buttonTag: buttonTag).teamAverageValue
    }

    func dataAverage(section: Int, item: Int, buttonTag: Int = 0) -> CGFloat {
        return statistics(section: section, item: item, buttonTag: buttonTag).dataAverageValue
    }
}

// MARK: - Private

private extension ChartViewModel {

    func sortCharts(startingSection: StatisticsSectionType) {
        var criticalSectionTypes = [StatisticsSectionType: CGFloat]()

        StatisticsSectionType.allValues.forEach { (sectionType: StatisticsSectionType) in
            let universeValue = (sectionType.universeChartTypes.flatMap { $0.statistics(allCharts).universe }).reduce(0, +)
            criticalSectionTypes[sectionType] = universeValue.toFloat
        }

        sortedSections = criticalSectionTypes.sorted { $0.value > $1.value }.flatMap { $0.key }
        sortedSections.remove(object: startingSection)
        sortedSections.insert(startingSection, at: 0)
    }
}
