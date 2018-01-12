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

    lazy var viewData: MyUniverseViewData = {
        return fetchViewData()
    }()
    var updateBlock: ((MyUniverseViewData) -> Void)?

    init(services: Services) {
        self.services = services
        myToBeVisions = services.userService.myToBeVisions()
        partners = services.partnerService.partners
        userChoices = services.userService.userChoices()
        statistics = services.statisticsService.chartObjects()
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)

        syncStateObserver.observe(\SyncStateObserver.syncedClasses, options: [.new]) { [unowned self] _, _ in
            if self.viewData.isLoading {
                self.update()
            }
        }.addTo(tokenBin)
        myToBeVisions.addNotificationBlock { [unowned self] _ in
            self.update()
        }.addTo(tokenBin)
        partners.addNotificationBlock { [unowned self] _ in
            self.update()
        }.addTo(tokenBin)
        userChoices.addNotificationBlock { [unowned self] _ in
            self.update()
        }.addTo(tokenBin)
        statistics.addNotificationBlock { [unowned self] _ in
            self.update()
        }.addTo(tokenBin)
    }

    // MARK: - private

    private func update() {
        viewData = fetchViewData()
        updateBlock?(viewData)
    }

    private func fetchViewData() -> MyUniverseViewData {
        let myToBeVision = services.userService.myToBeVision()
        // TODO: uncomment and re-implement when available. Also delete FIXME at bottom
//        let partners = self.partners.prefix(Layout.MeSection.maxPartners).map {
//            return MyUniverseViewData.Partner(imageURL: $0.profileImageResource?.url, initials: $0.initials.uppercased())
//        }
        let partners = [
            Partner.comingSoon(image: R.image.partner_comingSoon_01(), imageName: "partner_comingSoon_01"),
            Partner.comingSoon(image: R.image.partner_comingSoon_02(), imageName: "partner_comingSoon_02"),
            Partner.comingSoon(image: R.image.partner_comingSoon_03(), imageName: "partner_comingSoon_03")
        ]
        let userChoices = self.userChoices.sorted { $0.startDate > $1.startDate }
        let weeklyChices = userChoices.prefix(Layout.MeSection.maxWeeklyPage).map { choice -> WeeklyChoice in
            return WeeklyChoice(
                localID: choice.localID,
                contentCollectionID: choice.contentCollectionID ?? 0,
                categoryID: choice.contentCategoryID ?? 0,
                categoryName: "",
                title: choice.contentCollection?.title,
                startDate: choice.startDate,
                endDate: choice.endDate,
                selected: true
            )
        }
        let sectors = [
            sector(for: .peakPerformance, startAngle: 235, endAngle: 245),
            sector(for: .intensity, startAngle: 215, endAngle: 225),
            sector(for: .meetings, startAngle: 185, endAngle: 205),
            sector(for: .travel, startAngle: 145, endAngle: 175),
            sector(for: .sleep, startAngle: 125, endAngle: 135),
            sector(for: .activity, startAngle: 105, endAngle: 115)
        ]

        return MyUniverseViewData(
            profileImageURL: myToBeVision?.profileImageResource?.url,
            partners: partners,
            weeklyChoices: weeklyChices,
            myToBeVisionText: myToBeVision?.text ?? R.string.localized.meSectorMyWhyVisionMessagePlaceholder(),
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
        return MyUniverseViewData.Sector(
            type: type,
            title: type.title.uppercased(),
            titleColor: titleColor(for: type),
            titleSize: titleSize(for: type),
            startAngle: startAngle,
            endAngle: endAngle,
            lines: type.universeChartTypes.map({ line(for: $0) })
        )
    }

    private func line(for chartType: ChartType) -> MyUniverseViewData.Line {
        return MyUniverseViewData.Line(
            color: .white,
            dot: dot(for: chartType),
            chartType: chartType
        )
    }

    private func dot(for chartType: ChartType) -> MyUniverseViewData.Dot {
        return MyUniverseViewData.Dot(
            fillColor: fillColor(for: chartType),
            strokeColor: strokeColor(for: chartType),
            lineWidth: lineWidth(for: chartType),
            radius: radius(for: chartType),
            distance: distance(for: chartType)
        )
    }

    private func distance(for chartType: ChartType) -> CGFloat {
        return services.statisticsService.chart(key: chartType.rawValue)?.universeValue ?? 0
    }

    private func radius(for chartType: ChartType) -> CGFloat {
        let value = services.statisticsService.chart(key: chartType.rawValue)?.universeValue ?? 0
        return max(value, 0.1) * 10
    }

    private func fillColor(for chartType: ChartType) -> UIColor {
        guard let chart = services.statisticsService.chart(key: chartType.rawValue) else {
            return .clear
        }
        let isRed = chart.universeValue > 0.55
        if chartType.isBodyBrain {
            if isRed {
                return UIColor(red: 1, green: 0, blue: 34/255, alpha: 0.2)
            } else {
                return .white20
            }
        } else {
            if isRed {
                return UIColor(red: 255/255, green: 0, blue: 38/255, alpha: 1)
            } else {
                return .white
            }
        }
    }

    private func strokeColor(for chartType: ChartType) -> UIColor {
        guard let chart = services.statisticsService.chart(key: chartType.rawValue) else {
            return .clear
        }
        let isRed = chart.universeValue > 0.55
        if chartType.isBodyBrain {
            if isRed {
                return UIColor(red: 255/255, green: 0, blue: 38/255, alpha: 1)
            } else {
                return .white
            }
        } else {
            if isRed {
                return UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 0.9)
            } else {
                return .white60
            }
        }
    }

    private func lineWidth(for chartType: ChartType) -> CGFloat {
        let radius = self.radius(for: chartType)
        return chartType.isBodyBrain ? radius * 0.4 : radius * 0.1
    }

    private func titleColor(for section: StatisticsSectionType) -> UIColor {
        for chartType in section.universeChartTypes {
            if let chart = services.statisticsService.chart(key: chartType.rawValue),
                chart.universeValue > chart.teamAverageValue {
                return .cherryRedTwo
            }
        }
        return .white40
    }

    private func titleSize(for section: StatisticsSectionType) -> CGFloat {
        for chartType in section.universeChartTypes {
            if let chart = services.statisticsService.chart(key: chartType.rawValue),
                chart.universeValue > chart.teamAverageValue {
                return 15
            }
        }
        return 11
    }
}

// FIXME: remove when feature is available

extension Partner {
    static func comingSoon(image: UIImage?, imageName: String) -> MyUniverseViewData.Partner {
        guard let image = image, let url = try? image.save(withName: imageName, format: .png) else {
            return MyUniverseViewData.Partner(imageURL: nil, initials: "")
        }
        return MyUniverseViewData.Partner(imageURL: url, initials: "")
    }
}
