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

    // MARK: - Properties

    fileprivate let services: Services
    fileprivate var preparations: AnyRealmCollection<Preparation>?
    fileprivate var preparationChecks: AnyRealmCollection<PreparationCheck>?
    fileprivate var preparationsNotificationHandler: NotificationTokenHandler?
    fileprivate var preparationChecksNotificationHandler: NotificationTokenHandler?
    let updates = PublishSubject<CollectionUpdate, NoError>()
    let itemCountUpdate = ReplayOneSubject<Int, NoError>()

    fileprivate var items = [Item]() {
        didSet {
            updates.next(.reload)
        }
    }

    // MARK: - Init

    init(services: Services) {
        self.services = services
        preparations = try? services.preparationService.preparationsOnBackground(predicate: NSPredicate(format: "deleted == false"))
        preparationChecks = try? services.preparationService.preparationChecksOnBackground()
        preparationsNotificationHandler = preparations?.addNotificationBlock { [unowned self] (change: RealmCollectionChange<AnyRealmCollection<Preparation>>) in
            switch change {
            case .update(_, let deletions, let insertions, _):
                guard insertions.count == 0 else {
                    self.refresh()
                    return
                }
                self.updates.next(.willBegin)
                deletions.sorted(by: >).forEach({ (index: Int) in
                  self.items.remove(at: index)
                })
                let deletionPaths = deletions.map({ IndexPath(row: $0, section: 0) })
                self.updates.next(.update(deletions: deletionPaths, insertions: [], modifications: []))
                self.updates.next(.didFinish)
            default:
                break
            }
        }.handler
        preparationChecksNotificationHandler = preparationChecks?.addNotificationBlock { [unowned self] (change: RealmCollectionChange<AnyRealmCollection<PreparationCheck>>) in
            switch change {
            case .update(_, _, _, let modifications):
                guard modifications.count > 0 else {
                    return
                }
                self.refresh()
            default:
                break
            }
        }.handler
        
        refresh()
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> MyPrepViewModel.Item {
        return items[index]
    }
    
    func deleteItem(at index: Index) throws {
        try services.preparationService.deletePreparation(withLocalID: items[index].localID)
        itemCountUpdate.next(itemCount - 1)
    }
    
    private func refresh() {
        guard let preparations = preparations else {
            return
        }
        do {
            var items: [Item] = []
            try preparations.forEach({ (preparation: Preparation) in
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
                items.append(Item(localID: preparation.localID,
                                  header: preparation.subtitle,
                                  text: preparation.name,
                                  startDate: preparation.calendarEvent?.event?.startDate,
                                  totalPreparationCount: contentItemIDs.count,
                                  finishedPreparationCount: finishedPreparationCount))
            })
            self.items = items
            itemCountUpdate.next(itemCount)
        } catch let error {
            print("Failed to update MyPrepViewModel: \(error)")
        }
    }
}
