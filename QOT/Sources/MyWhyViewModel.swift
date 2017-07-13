//
//  MyWhyViewModel.swift
//  QOT
//
//  Created by karmic on 13.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class MyWhyViewModel {

    // MARK: - Properties

    let items: [MyWhy]
    let partners: AnyRealmCollection<Partner>
    let myToBeVision: MyToBeVision?
    let updates = PublishSubject<CollectionUpdate, NoError>()
    private var partnersNotificationToken: NotificationToken?
    private var visionNotificationToken: NotificationToken?

    var itemCount: Int {
        return items.count
    }

    func itemCount(for myWhyItem: MyWhy) -> Int {
        switch myWhyItem {
        case .vision: return 0
        case .weeklyChoices(_, let choices): return choices.count
        case .partners(_, let partners): return partners.count
        }
    }
    
    init(partners: AnyRealmCollection<Partner>, vision: MyToBeVision?) {
        items = [
            .vision(vision),
            .weeklyChoices(title: R.string.localized.meSectorMyWhyWeeklyChoicesTitle(), choices: weeklyChoices),
            .partners(title: R.string.localized.meSectorMyWhyPartnersTitle(), partners: partners)
        ]
        self.partners = partners
        myToBeVision = vision

        partnersNotificationToken = partners.addNotificationBlock { (changes: RealmCollectionChange<AnyRealmCollection<Partner>>) in
            switch changes {
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.updates.next(.reload)
                break
            default:
                break
            }
        }
        visionNotificationToken = myToBeVision?.addNotificationBlock { (change: ObjectChange) in
            switch change {
            case .change:
                self.updates.next(.reload)
                break
            default:
                break
            }
        }
    }
    
    deinit {
        partnersNotificationToken?.stop()
        visionNotificationToken?.stop()
    }
}

enum MyWhy {
    case vision(MyToBeVision?)
    case weeklyChoices(title: String, choices: [WeeklyChoice])
    case partners(title: String, partners: AnyRealmCollection<Partner>)

    enum Index: Int {
        case vision = 0
        case weeklyChoices = 1
        case partners = 2
    }
}

private var weeklyChoices: [WeeklyChoice] {
    return [
        WeeklyChoice(
            localID: UUID().uuidString,
            contentCollectionID: 0,
            categoryID: 0,
            title: "You are having a Lorem ipsum here and",
            startDate: Date(),
            endDate: Date(),
            selected: false
        ),

        WeeklyChoice(
            localID: UUID().uuidString,
            contentCollectionID: 0,
            categoryID: 0,
            title: "You are having a Lorem ipsum here and",
            startDate: Date(),
            endDate: Date(),
            selected: false
        ),

        WeeklyChoice(
            localID: UUID().uuidString,
            contentCollectionID: 0,
            categoryID: 0,
            title: "You are having a Lorem ipsum here and",
            startDate: Date(),
            endDate: Date(),
            selected: false
        ),

        WeeklyChoice(
            localID: UUID().uuidString,
            contentCollectionID: 0,
            categoryID: 0,
            title: "You are having a Lorem ipsum here and",
            startDate: Date(),
            endDate: Date(),
            selected: false
        ),

        WeeklyChoice(
            localID: UUID().uuidString,
            contentCollectionID: 0,
            categoryID: 0,
            title: "You are having a Lorem ipsum here and",
            startDate: Date(),
            endDate: Date(),
            selected: false
        )
    ]
}
