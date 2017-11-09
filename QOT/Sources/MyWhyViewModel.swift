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
    enum MyWhy {
        case vision(MyToBeVision?)
        case weeklyChoices(title: String, choices: [WeeklyChoice])
        case partners(title: String, partners: AnyRealmCollection<Partner>)
        
        enum Index: Int {
            case vision = 0
            case weeklyChoices
            case partners
        }
    }

    // MARK: - Properties

    var items: [MyWhy]?
    let partners: AnyRealmCollection<Partner>
    private(set) var myToBeVision: MyToBeVision?
    let userChoices: AnyRealmCollection<UserChoice>
    let updates = PublishSubject<CollectionUpdate, NoError>()
    private let services: Services
    private var partnersNotificationTokenHandler: NotificationTokenHandler?
    private var visionNotificationTokenHandler: NotificationTokenHandler?
    private var visionsNotificationTokenHandler: NotificationTokenHandler?
    private var userChoiceNotificationTokenHandler: NotificationTokenHandler?
    private var profileImageNotificationTokenHandler: NotificationTokenHandler?
    private var maxWeeklyItems: Int {
        return Layout.MeSection.maxWeeklyPage
    }
    
    var itemCount: Int {
        return items?.count ?? 0
    }

    func itemCount(for myWhyItem: MyWhy) -> Int {
        switch myWhyItem {
        case .vision: return 0
        case .weeklyChoices(_, let choices): return choices.count
        case .partners(_, let partners): return partners.count
        }
    }

    // MARK: - Init
    
    init(services: Services) {
        self.services = services
        self.partners = services.partnerService.partners
        self.myToBeVision = services.userService.myToBeVision()
        self.userChoices = services.userService.userChoices()

        partnersNotificationTokenHandler = partners.addNotificationBlock { [weak self] (changes: RealmCollectionChange<AnyRealmCollection<Partner>>) in
            switch changes {
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.updates.next(.reload)
                break
            default:
                break
            }
        }.handler
        visionNotificationTokenHandler = myToBeVision?.addNotificationBlock { [weak self] (change: ObjectChange) in
            switch change {
            case .change:
                self?.updates.next(.reload)
                break
            default:
                break
            }
        }.handler
        visionsNotificationTokenHandler = services.userService.myToBeVisions().addNotificationBlock { [weak self] (changes: RealmCollectionChange<AnyRealmCollection<MyToBeVision>>) in
            switch changes {
            case .update(_, _, let insertions, _):
                // myToBeVision may be nil when app first starts. so set it again when first object [0] is inserted
                guard insertions.count > 0, insertions[0] == 0 else { return }
                self?.myToBeVision = services.userService.myToBeVision()
                self?.refreshDataSource()
                self?.updates.next(.reload)
            default:
                break
            }
        }.handler
        profileImageNotificationTokenHandler = myToBeVision?.profileImageResource?.addNotificationBlock { [weak self]  (change: ObjectChange) in
            switch change {
            case .change:
                self?.updates.next(.reload)
                NotificationCenter.default.post(name: .startSyncUploadMediaNotification, object: nil)
                break
            default:
                break
            }
        }.handler
        userChoiceNotificationTokenHandler = userChoices.addNotificationBlock { [weak self] (changes: RealmCollectionChange<AnyRealmCollection<UserChoice>>) in
            switch changes {
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.refreshDataSource()
                self?.updates.next(.reload)
                break
            default:
                break
            }
        }.handler
        
        refreshDataSource()
    }
    
    // MARK: - private
    
    private func refreshDataSource() {
        var userChoices = self.userChoices.sorted { $0.startDate > $1.startDate }
        userChoices = (userChoices.count > maxWeeklyItems) ? Array(userChoices[0...maxWeeklyItems-1]) : userChoices
        let weeklyChoices: [WeeklyChoice] = userChoices.map { (userChoice: UserChoice) -> WeeklyChoice in
            var title: String?
            if let contentCollectionID = userChoice.contentCollectionID, let contentCollection = self.services.contentService.contentCollection(id: contentCollectionID) {
                title = contentCollection.title
            }
            return WeeklyChoice(
                localID: userChoice.localID,
                contentCollectionID: userChoice.contentCollectionID ?? 0,
                categoryID: userChoice.contentCategoryID ?? 0,
                title: title,
                startDate: userChoice.startDate,
                endDate: userChoice.endDate,
                selected: true
            )
        }
        items = [
            .vision(myToBeVision),
            .weeklyChoices(title: R.string.localized.meSectorMyWhyWeeklyChoicesTitle(), choices: weeklyChoices),
            .partners(title: R.string.localized.meSectorMyWhyPartnersTitle(), partners: partners)
        ]
    }
}
