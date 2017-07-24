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

    struct Item {
        let localID: String
        let header: String
        let text: String
        let startDate: Date?
        let totalPreparationCount: Int
        let finishedPreparationCount: Int
    }

    fileprivate let queue = DispatchQueue(label: "MyPrepViewModel.queue")
    fileprivate let services: Services
    fileprivate let realmObserver: RealmObserver
    fileprivate var items: [Item] = [] {
        didSet { updates.next(items) }
    }

    let updates = PublishSubject<[Item], NoError>()

    init(services: Services) {
        self.services = services
        self.realmObserver = RealmObserver(realm: services.mainRealm)

        refresh()

        realmObserver.handler = { [weak self] in
            self?.refresh()
        }
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> Item {
        return items[index]
    }

    private func refresh() {
        queue.async { [weak self] in
            guard let strongSelf = self else {
                return
            }

            do {
                let preparations = try strongSelf.services.preparationService.preparationsOnBackground()
                var items: [Item] = []
                for preparation in preparations {
                    let contentItems = Array(try strongSelf.services.contentService.contentItemsOnBackground(contentID: preparation.contentID))
                    let contentItemIDs = contentItems.filter ({ (contentItem) -> Bool in
                        switch contentItem.contentItemValue {
                        case .prepareStep:
                            return true
                        default:
                            return false
                        }
                    }).map { $0.remoteID }
                    let preparationChecks = try strongSelf.services.preparationService.preparationChecksOnBackground(preparationID: preparation.localID)

                    var startDate: Date? = nil
                    if let eventID = preparation.eventID {
                        startDate = strongSelf.services.eventsService.eventStore.event(withIdentifier: eventID)?.startDate
                    }

                    let item = Item(localID: preparation.localID,
                                    header: preparation.subtitle,
                                    text: preparation.title,
                                    startDate: startDate,
                                    totalPreparationCount: contentItemIDs.count,
                                    finishedPreparationCount: preparationChecks.count)

                    items.append(item)
                }

                DispatchQueue.main.async {
                    strongSelf.items = items
                }
            } catch let error {
                print("Failed to update MyPrepViewModel: \(error)")
            }
        }
    }
}
