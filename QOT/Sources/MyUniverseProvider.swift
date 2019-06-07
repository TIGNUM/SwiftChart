//
//  MyUniverseProvider.swift
//  QOT
//
//  Created by Lee Arromba on 29/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class MyUniverseProvider {

    private let services: Services
    private let myToBeVisions: AnyRealmCollection<MyToBeVision>
    private let partners: AnyRealmCollection<QOT.Partner>
    private let userChoices: AnyRealmCollection<UserChoice>
    private let statistics: AnyRealmCollection<Statistics>
    private let syncStateObserver: SyncStateObserver
    private let tokenBin = TokenBin()
    lazy var viewData = fetchViewData()
    var updateBlock: ((MyUniverseViewData) -> Void)?

    init(services: Services) {
        self.services = services
        myToBeVisions = services.userService.myToBeVisions()
        partners = services.partnerService.partners
        userChoices = services.userService.userChoices()
        statistics = services.statisticsService.chartObjects()
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)

        syncStateObserver.onUpdate { [unowned self] _ in
            if self.viewData.isLoading == true {
                self.update()
            }
        }
        tokenBin.addToken(myToBeVisions.observe { [unowned self] _ in
            self.update()
        })
        tokenBin.addToken(partners.observe { [unowned self] _ in
            self.update()
        })
        tokenBin.addToken(userChoices.observe { [unowned self] _ in
            self.update()
        })
        tokenBin.addToken(statistics.observe { [unowned self] _ in
            self.update()
        })
    }

    // MARK: - private

    private func update() {
        viewData = fetchViewData()
        updateBlock?(viewData)
    }

    private func fetchViewData() -> MyUniverseViewData {
        let myToBeVision = services.userService.myToBeVision()
        let myToBeVisionText = myToBeVision?.text ?? services.contentService.toBeVisionMessagePlaceholder()
        let realmPartners =
            services.partnerService.lastModifiedPartnersSortedByCreatedAtAscending(maxCount: 3).filter { $0.isValid }
        let dataPartners = realmPartners.map { (realmPartner) -> MyUniverseViewData.Partner in
            let url = realmPartner.profileImageResource?.url
            return MyUniverseViewData.Partner(imageURL: url, initials: realmPartner.initials.uppercased())
        }
        let userChoices = self.userChoices.sorted { $0.startDate > $1.startDate }
        let weeklyChoices = userChoices.prefix(Layout.MeSection.maxWeeklyPage).map { choice -> WeeklyChoice in
            return WeeklyChoice(
                localID: choice.localID,
                contentCollectionID: choice.contentCollectionID ?? 0,
                categoryID: choice.contentCategoryID ?? 0,
                categoryName: "",
                title: choice.contentCollection?.title,
                covered: nil,
                startDate: choice.startDate,
                endDate: choice.endDate,
                displayTime: "",
                isDefault: false,
                selected: true
            )
        }
        let sectors = [
            sector(for: .intensity, startAngle: 210, endAngle: 220),
            sector(for: .meetings, startAngle: 185, endAngle: 205),
            sector(for: .sleep, startAngle: 135, endAngle: 145),
            sector(for: .activity, startAngle: 115, endAngle: 125)
        ]
        return MyUniverseViewData(
            profileImageURL: myToBeVision?.imageURL,
            partners: dataPartners  ,
            weeklyChoices: weeklyChoices,
            myToBeVisionHeadline: myToBeVision?.headline ?? R.string.localized.meSectorMyWhyVisionTitle(),
            myToBeVisionText: myToBeVisionText ?? R.string.localized.meSectorMyWhyVisionMessagePlaceholder(),
            sectors: sectors,
            isLoading: !isReady()
        )
    }

    private func isReady() -> Bool {
        return syncStateObserver.hasSynced(MyToBeVision.self)
            && syncStateObserver.hasSynced(Partner.self)
            && syncStateObserver.hasSynced(UserChoice.self)
            && syncStateObserver.hasSynced(Statistics.self)
    }

    private func sector(for type: StatisticsSectionType,
                        startAngle: CGFloat,
                        endAngle: CGFloat) -> MyUniverseViewData.Sector {
        return MyUniverseViewData.Sector(type: type,
                                         title: type.title.uppercased(),
                                         titleColor: titleColor(for: type),
                                         titleSize: titleSize(for: type),
                                         startAngle: startAngle,
                                         endAngle: endAngle,
                                         lines: type.universeChartTypes.map { line(for: $0) })
    }

    private func line(for chartType: ChartType) -> MyUniverseViewData.Line {
        return MyUniverseViewData.Line(color: .white,
                                       dot: dot(for: chartType),
                                       chartType: chartType)
    }

    private func dot(for chartType: ChartType) -> MyUniverseViewData.Dot {
        return MyUniverseViewData.Dot(fillColor: fillColor(for: chartType),
                                      strokeColor: strokeColor(for: chartType),
                                      lineWidth: lineWidth(for: chartType),
                                      radius: radius(for: chartType),
                                      distance: distance(for: chartType))
    }

    private func distance(for chartType: ChartType) -> CGFloat {
        return statistics(chartType)?.universeValue ?? 0
    }

    private func radius(for chartType: ChartType) -> CGFloat {
        return max(distance(for: chartType), 0.1) * 10
    }

    private func fillColor(for chartType: ChartType) -> UIColor {
        let isCritical = critical(chartType)
        if chartType.isBodyBrain {
            return isCritical == true ? .cherryRed20 : .white20
        }
        return isCritical == true ? .cherryRedTwo : .white
    }

    private func strokeColor(for chartType: ChartType) -> UIColor {
        let isCritical = critical(chartType)
        if chartType.isBodyBrain {
            return isCritical == true ? .cherryRedTwo : .white
        }

        return isCritical == true ? .cherryRed : .white60
    }

    private func lineWidth(for chartType: ChartType) -> CGFloat {
        let radius = self.radius(for: chartType)
        return chartType.isBodyBrain ? radius * 0.4 : radius * 0.1
    }

    private func titleColor(for section: StatisticsSectionType) -> UIColor {
        for chartType in section.universeChartTypes {
            return critical(chartType) == true ? .cherryRedTwo : .white
        }
        return .white
    }

    private func titleSize(for section: StatisticsSectionType) -> CGFloat {
        for chartType in section.universeChartTypes {
            return critical(chartType) == true ? 13 : 11
        }
        return 11
    }

    private func critical(_ chartType: ChartType) -> Bool {
        guard let chart = statistics(chartType) else { return false }
        return chart.universeValue > 0.55
    }

    private func statistics(_ chartType: ChartType) -> Statistics? {
        return services.statisticsService.chart(key: chartType.rawValue)
    }
}
