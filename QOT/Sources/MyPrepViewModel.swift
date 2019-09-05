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
    private let widgetDataManager: ExtensionsDataManager
    private var preparations: AnyRealmCollection<Preparation>?
    private var preparationChecks: AnyRealmCollection<PreparationCheck>?
    private var preparationsNotificationHandler: NotificationTokenHandler?
    private var preparationChecksNotificationHandler: NotificationTokenHandler?
    private let syncStateObserver: SyncStateObserver
    private var items = [Item]() {
        didSet {
            updates.send(.reload)
        }
    }
    let updates = PassthroughSubject<CollectionUpdate, Never>()
    let itemCountUpdate = ReplayOneSubject<Int, Never>()

    enum Section {
        case future
        case past
    }

    private var futurePreparations: [Item] = []
    private var pastPreparations: [Item] = []

    init(services: Services) {
        self.services = services
        self.widgetDataManager = ExtensionsDataManager()
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        preparations = try? services.preparationService.preparationsOnBackground(predicate: NSPredicate(format: "deleted == false"))
        preparationChecks = try? services.preparationService.preparationChecksOnBackground()
        preparationsNotificationHandler = preparations?.observe { [unowned self] (change: RealmCollectionChange<AnyRealmCollection<Preparation>>) in
            switch change {
            case .update(_, _, let insertions, _):
                guard insertions.isEmpty == true else {
                    self.refresh()
                    return
                }
                self.updates.send(.reload)
            default: break
            }
        }.handler
        preparationChecksNotificationHandler = preparationChecks?.observe { [unowned self] (change: RealmCollectionChange<AnyRealmCollection<PreparationCheck>>) in
            switch change {
            case .update(_, _, _, let modifications):
                guard modifications.isEmpty == false else { return }
                self.refresh()
            default: break
            }
        }.handler
        syncStateObserver.onUpdate { [unowned self] _ in
            self.updates.send(.reload)
        }
        refresh()
        widgetDataManager.update(.upcomingEvent)
    }

    var initialItem: Int? {
        return max(items.filter { $0.startDate?.timeIntervalSinceNow.sign == .plus }.count - 1, 0)
    }

    var itemCount: Int {
        return futureItemCount + pastItemCount
    }

    var futureItemCount: Int {
        return futurePreparations.count
    }

    var pastItemCount: Int {
        return pastPreparations.count
    }

    var sections = [Section]()

    func item(at indexPath: IndexPath) -> MyPrepViewModel.Item {
        switch sections[indexPath.section] {
        case .future:
            return futurePreparations[indexPath.row]
        case .past:
            return pastPreparations[indexPath.row]
        }
    }

    func itemCount(at section: Index) -> Int {
        switch sections[section] {
        case .future:
            return futureItemCount
        case .past:
            return pastItemCount
        }
    }

    func itemTypeString(at section: Index) -> String? {
        switch sections[section] {
        case .future:
            return R.string.localized.prepareMyPrepTableviewSectionHeaderUpCommingPreparations()
        case .past:
            return R.string.localized.prepareMyPrepTableviewSectionHeaderPastPreparations()
        }
    }

    func deleteItem(at indexPath: IndexPath) throws {
        try services.preparationService.deletePreparation(withLocalID: item(at: indexPath).localID)
        widgetDataManager.update(.upcomingEvent)
        refresh()
    }

    func isReady() -> Bool {
        return syncStateObserver.hasSynced(Preparation.self) && syncStateObserver.hasSynced(PreparationCheck.self)
    }
}

// MARK: - Private

private extension MyPrepViewModel {

    func refresh() {
        guard let preparations = preparations else { return }
        var items = [Item]()
        preparations.forEach { (preparation: Preparation) in
            items.append(Item(localID: preparation.localID,
                              header: preparation.subtitle,
                              text: preparation.name,
                              startDate: preparation.calendarEvent()?.startDate,
                              endDate: preparation.calendarEvent()?.endDate,
                              totalPreparationCount: preparation.checkableItems.count,
                              finishedPreparationCount: preparation.coveredChecks.count))
        }

        let now = Date()
        var futurePreparations = [Item]()
        var pastPreparations = [Item]()
        items.forEach { (item: MyPrepViewModel.Item) in
            guard let startDate = item.startDate else {
                return
            }
            if startDate > now {
                futurePreparations.append(item)
            } else {
                pastPreparations.append(item)
            }
        }
        self.futurePreparations = futurePreparations.sorted {
            if let firstStartDate = $0.startDate, let nextStartDate = $1.startDate {
                return firstStartDate < nextStartDate
            }
            return true
        }

        self.pastPreparations = pastPreparations.sorted {
            if let firstStartDate = $0.startDate, let nextStartDate = $1.startDate {
                return firstStartDate < nextStartDate
            }
            return true
        }

        sections = []
        if self.futurePreparations.count > 0 {
            sections.append(.future)
        }
        if self.pastPreparations.count > 0 {
            sections.append(.past)
        }
        self.items = self.futurePreparations + self.pastPreparations
        itemCountUpdate.send(itemCount)
    }
}
