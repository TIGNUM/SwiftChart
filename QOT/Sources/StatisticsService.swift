//
//  StatisticsService.swift
//  QOT
//
//  Created by karmic on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class StatisticsService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }
    
    func eraseData() {
        do {
            try mainRealm.write {
                mainRealm.delete(chartObjects())
            }
        } catch {
            assertionFailure("Failed to delete chartObjects with error: \(error)")
        }
    }

    func chartObjects() -> AnyRealmCollection<Statistics> {
        let results = mainRealm.objects(Statistics.self)
        
        return AnyRealmCollection(results)
    }

    func chart(key: String) -> Statistics? {
        let predicate = NSPredicate(format: "key == %@", key)

        return chartObjects().filter(predicate).first
    }

    func charts() throws -> [[Statistics]] {
        var results = [[Statistics]]()

        StatisticsSectionType.allValues.forEach { (sectionType: StatisticsSectionType) in

            sectionType.chartTypes.forEach { (chartTypes: [ChartType]) in
                var chartSections = [Statistics]()

                chartTypes.forEach { (chartType: ChartType) in
                    if let chart = chart(key: chartType.rawValue) {
                        chart.chartType = chartType
                        chart.title = chartType.title
                        chartSections.append(chart)
                    }
                }

                results.append(chartSections)
            }
        }

        return results
    }
}
