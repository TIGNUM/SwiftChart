//
//  MyPrepViewModel.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit

enum MyPrepCellType {
    case placeholder(String)
    case item(MyPrepViewModel.Item)
}

final class MyPrepViewModel {
    
    enum CollectionUpdate {
        case willBegin
        case didFinish
        case reload
        case update(deletions: [IndexPath], insertions: [IndexPath], modifications: [IndexPath])
    }
    
    struct Item {
        let localID: String
        let header: String
        let text: String
        let startDate: Date?
        let totalPreparationCount: Int
        let finishedPreparationCount: Int
    }

    fileprivate let services: Services
    fileprivate var preparations: AnyRealmCollection<Preparation>?
    fileprivate var notificationHandler: NotificationTokenHandler?
    fileprivate var items = [Item]() {
        didSet {
            updates.next(.reload)
        }
    }
    let updates = PublishSubject<CollectionUpdate, NoError>()

    init(services: Services) {
        self.services = services
        preparations = try? services.preparationService.preparationsOnBackground(predicate: NSPredicate(format: "deleted == false"))
        
        refresh()

        notificationHandler = preparations?.addNotificationBlock({ [unowned self] (change: RealmCollectionChange<AnyRealmCollection<Preparation>>) in
            switch change {
            case .update(_, let deletions, let insertions, _):
                guard insertions.count == 0 else {
                    self.refresh()
                    return
                }
                self.updates.next(.willBegin)
                deletions.forEach({ (index: Int) in
                    self.items.remove(at: index)
                })
                let deletionPaths = deletions.map({ IndexPath(row: $0, section: 0) })
                self.updates.next(.update(deletions: deletionPaths, insertions: [], modifications: []))
                self.updates.next(.didFinish)
            default:
                self.refresh()
            }
        }).handler
    }

    var itemCount: Int {
        return items.count > 0 ? items.count : 1
    }

    func item(at index: Index) -> MyPrepCellType {
        return items.count > 0 ? MyPrepCellType.item(items[index]) : MyPrepCellType.placeholder("SOME PLACEHOLDER TEXT")
    }
    
    func deleteItem(at index: Index) throws {
        try services.preparationService.deletePreparation(withLocalID: items[index].localID)
    }
    
    private func refresh() {
        guard let preparations = preparations else {
            return
        }
        do {
            var items: [Item] = []
            for preparation in preparations {
                let contentItems = Array(try self.services.contentService.contentItemsOnBackground(contentCollectionID: preparation.contentCollectionID))
                let contentItemIDs = contentItems.filter ({ (contentItem) -> Bool in
                    switch contentItem.contentItemValue {
                    case .prepareStep:
                        return true
                    default:
                        return false
                    }
                }).map { $0.remoteID }
                
                let preparationChecks = try self.services.preparationService.preparationChecksOnBackground(preparationID: preparation.localID)
                let finishedPreparationCount = preparationChecks.reduce(0, { (result: Int, check: PreparationCheck) -> Int in
                    return (check.covered == nil) ? result : result + 1
                })
                let item = Item(localID: preparation.localID,
                                header: preparation.subtitle,
                                text: preparation.name,
                                startDate: preparation.calendarEvent?.event?.startDate,
                                totalPreparationCount: contentItemIDs.count,
                                finishedPreparationCount: finishedPreparationCount)
                items.append(item)
            }
            self.items = items
        } catch let error {
            print("Failed to update MyPrepViewModel: \(error)")
        }
    }
}
