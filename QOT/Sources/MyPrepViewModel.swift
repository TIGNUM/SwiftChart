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
        let endDate: Date?
        let totalPreparationCount: Int
        let finishedPreparationCount: Int
    }

    private let services: Services
    private var preparations: AnyRealmCollection<Preparation>?
    private var preparationChecks: AnyRealmCollection<PreparationCheck>?
    private var preparationsNotificationHandler: NotificationTokenHandler?
    private var preparationChecksNotificationHandler: NotificationTokenHandler?
    private let syncStateObserver: SyncStateObserver
    private var items = [Item]() {
        didSet {
            updates.next(.reload)
        }
    }
    let updates = PublishSubject<CollectionUpdate, NoError>()
    let itemCountUpdate = ReplayOneSubject<Int, NoError>()

    init(services: Services) {
        self.services = services
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        preparations = try? services.preparationService.preparationsOnBackground(predicate: NSPredicate(format: "deleted == false"))
        preparationChecks = try? services.preparationService.preparationChecksOnBackground()
        preparationsNotificationHandler = preparations?.addNotificationBlock { [unowned self] (change: RealmCollectionChange<AnyRealmCollection<Preparation>>) in
            switch change {
            case .update(_, _, let insertions, _):
                guard insertions.count == 0 else {
                    self.refresh()
                    return
                }
                self.updates.next(.reload)
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
        syncStateObserver.onUpdate { [unowned self] _ in
            self.updates.next(.reload)
        }

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
        refresh()
    }

    func isReady() -> Bool {
        return syncStateObserver.hasSynced(Preparation.self) && syncStateObserver.hasSynced(PreparationCheck.self)
    }

    // MARK: - private

    private func refresh() {
        guard let preparations = preparations else {
            return
        }

        do {
            var items: [Item] = []
            try preparations.forEach({ (preparation: Preparation) in
                let contentItems = Array(try self.services.contentService.contentItemsOnBackground(contentCollectionID: preparation.contentCollectionID))
                let contentItemIDs = contentItems.filter { (contentItem) -> Bool in
                    switch contentItem.contentItemValue {
                    case .prepareStep:
                        return true
                    default:
                        return false
                    }
                }.map { $0.remoteID }

                let preparationChecks = try self.services.preparationService.preparationChecksOnBackground(preparationID: preparation.localID)
                let finishedPreparationCount = preparationChecks.reduce(0, { (result: Int, check: PreparationCheck) -> Int in
                    return (check.covered == nil) ? result : result + 1
                })
                items.append(Item(localID: preparation.localID,
                                  header: preparation.subtitle,
                                  text: preparation.name,
                                  startDate: preparation.calendarEvent?.event?.startDate,
                                  endDate: preparation.calendarEvent?.event?.endDate,
                                  totalPreparationCount: contentItemIDs.count,
                                  finishedPreparationCount: finishedPreparationCount))
            })
            self.items = items
            itemCountUpdate.next(itemCount)
        } catch let error {
            log("Failed to update MyPrepViewModel: \(error)", level: .error)
        }
    }
}
