//
//  WeeklyChoicesProvider.swift
//  QOT
//
//  Created by Lee Arromba on 23/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

final class WeeklyChoicesProvider {
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

        notificationTokenHandler = userChoices.observe { [unowned self] change in
            self.updateBlock?(self.provideViewData())
        }.handler
    }

    func provideViewData() -> WeeklyChoicesViewData {
        var items = [WeeklyChoicesViewData.Item]()
        let userChoices = self.userChoices.sorted { $0.startDate > $1.startDate }
        userChoices.forEach { (userChoice: UserChoice) in
            var title: String?
            var contentCollection: ContentCollection?
            if let contentCollectionID = userChoice.contentCollectionID {
                contentCollection = services.contentService.contentCollection(id: contentCollectionID)
                title = contentCollection?.title
            }

            var categoryName: String?
            if let contentCategoryID = userChoice.contentCategoryID {
                categoryName = services.contentService.contentCategory(id: contentCategoryID)?.title
            } else {
                categoryName = contentCollection?.contentCategories.first?.title
            }

            let item = WeeklyChoicesViewData.Item(title: title,
                                                  subtitle: nil,
                                                  categoryName: categoryName,
                                                  contentCollectionID: userChoice.contentCollectionID,
                                                  categoryID: userChoice.contentCategoryID)
            items.append(item)
        }
        return WeeklyChoicesViewData(items: items)
    }
}
