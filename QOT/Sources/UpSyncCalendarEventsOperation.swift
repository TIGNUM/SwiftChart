//
//  UpSyncCalendarEvents.swift
//  QOT
//
//  Created by Sam Wyndham on 21.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit
import Freddy

final class UpSyncCalendarEventsOperation: ConcurrentOperation {

    private let networkManager: NetworkManager
    private let realmProvider: RealmProvider
    private let eventStore: EKEventStore
    private let context: SyncContext
    private let isFinalOperation: Bool

    init(networkManager: NetworkManager, realmProvider: RealmProvider, eventStore: EKEventStore = EKEventStore(), syncContext: SyncContext, isFinalOperation: Bool) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
        self.eventStore = eventStore
        self.context = syncContext
        self.isFinalOperation = isFinalOperation
    }

    override func execute() {
        startSyncAndContinue()
    }

    // MARK: Steps

    private func startSyncAndContinue() {
        let request = StartSyncRequest(from: 0) // Any from value is fine here as it is ignored by the server
        networkManager.request(request, parser: StartSyncResult.parse) { [weak self] (result) in
            switch result {
            case .success(let startSyncRestult):
                self?.fetchDirtyEventsAndContinue(nextSyncToken: startSyncRestult.syncToken)
            case .failure(let error):
                self?.finish(error: .upSyncCalendarEventsStartSyncFailed(error: error))
            }
        }
    }

    func fetchDirtyEventsAndContinue(maxItems: Int = 50, nextSyncToken: String) {
        do {
            let realm = try realmProvider.realm()
            let items = realm.dirtyCalandarEvents().prefix(maxItems)
            let jsons = items.flatMap { $0.json(eventStore: eventStore) }
            if jsons.count == 0 {
                finish(error: nil)
            } else {
                let body = try jsons.toJSON().serialize()
                sendBody(body, nextSyncToken: nextSyncToken)
            }
        } catch let error {
            finish(error: .upSyncFetchDirtyCalendarEventsFailed(error: error))
        }
    }

    func sendBody(_ body: Data, nextSyncToken: String) {
        let request = UpSyncRequest(endpoint: .calendarEvent, body: body, syncToken: nextSyncToken)
        networkManager.request(request, parser: UpSyncResultParser.parse) { [weak self] (result) in
            switch result {
            case .success(let upSyncResult):
                self?.saveUpSyncResult(result: upSyncResult)
            case .failure(let error):
                self?.finish(error: .upSyncSendCalendarEventsFailed(error: error))
            }
        }
    }

    func saveUpSyncResult(result: UpSyncResult) {
        do {
            let realm = try realmProvider.realm()
            realm.setCalendarEventRemoteIDs(remoteIDs: result.remoteIDs)
            fetchDirtyEventsAndContinue(nextSyncToken: result.nextSyncToken)
        } catch let error {
            finish(error: .upSyncSendCalendarEventsFailed(error: error))
        }
    }

    // MARK: Finish

    private func finish(error: SyncError?) {
        if let error = error {
            context.finish(error: error)
        } else if isFinalOperation {
            context.finish(error: nil)
        }

        finish()
    }
}
