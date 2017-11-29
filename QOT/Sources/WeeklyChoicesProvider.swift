//
//  WeeklyChoicesProvider.swift
//  QOT
//
//  Created by Lee Arromba on 23/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

class WeeklyChoicesProvider {
    private let services: Services
    private var userChoices: AnyRealmCollection<UserChoice>
    private let itemsPerPage: Int
    private var notificationTokenHandler: NotificationTokenHandler?
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        dateFormatter.locale = .current
        return dateFormatter
    }()
    var updateBlock: ((WeeklyChoicesViewData) -> Void)?

    init(services: Services, itemsPerPage: Int) {
        self.services = services
        self.userChoices = services.userService.userChoices()
        self.itemsPerPage = itemsPerPage

        notificationTokenHandler = userChoices.addNotificationBlock { [unowned self] change in
            self.updateBlock?(self.provideViewData())
        }.handler
    }

    func provideViewData() -> WeeklyChoicesViewData {
        // group choices by date
        let groupedChoices = Dictionary(grouping: self.userChoices, by: { $0.startDate })
        guard groupedChoices.count > 0 else {
            return WeeklyChoicesViewData(pages: [], itemsPerPage: 0)
        }

        // generate pages from keys sorted by date (newest first)
        var pages = [WeeklyChoicesViewData.Page]()
        groupedChoices.keys.sorted { $0 > $1 }.forEach { (key: Date) in
            // get dictionary values
            guard let values = groupedChoices[key] else { return }

            // cap values (i.e. no more than x choices)
            let cappedChoices = (values.count > itemsPerPage) ? Array(values[0...itemsPerPage-1]) : values

            // map to data model
            var items: [WeeklyChoicesViewData.Page.Item] = cappedChoices.map { (userChoice: UserChoice) -> WeeklyChoicesViewData.Page.Item in
                var title: String?
                if let contentCollectionID = userChoice.contentCollectionID {
                    title = services.contentService.contentCollection(id: contentCollectionID)?.title
                }
                var categoryName: String?
                if let contentCategoryID = userChoice.contentCategoryID {
                    categoryName = services.contentService.contentCategory(id: contentCategoryID)?.title
                }
                return WeeklyChoicesViewData.Page.Item(
                    title: title,
                    subtitle: nil,
                    categoryName: categoryName,
                    contentCollectionID: userChoice.contentCollectionID,
                    categoryID: userChoice.contentCategoryID
                )
            }

            // pad any missing entries
            if items.count < itemsPerPage {
                let item = WeeklyChoicesViewData.Page.Item(title: nil, subtitle: nil, categoryName: nil, contentCollectionID: nil, categoryID: nil)
                items += [WeeklyChoicesViewData.Page.Item](repeating: item, count: itemsPerPage - items.count)
            }

            // post generate subtitles
            for (index, item) in items.enumerated() {
                var item = item
                item.subtitle = R.string.localized.meSectorMyWhyWeeklyChoicesChoice(index + 1)
                items[index] = item
            }

            // create pages
            let startDate = key
            let endDate = key + TimeInterval(7 * 24 * 60 * 60) // + 7 days (1 week)
            let dateString = "\(dateFormatter.string(from: startDate)) // \(dateFormatter.string(from: endDate))"
            pages.append(WeeklyChoicesViewData.Page(
                startDate: startDate,
                endDate: endDate,
                dateString: dateString,
                items: items
            ))
        }

        return WeeklyChoicesViewData(pages: pages, itemsPerPage: itemsPerPage)
    }
}
