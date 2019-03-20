//
//  CalendarEventTests.swift
//  QOTTests
//
//  Created by Sanggeon Park on 24.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import XCTest
import Alamofire
import Realm
import JPSimulatorHacks

@testable import QOT

class CalendarEventTests: XCTestCase {

    var realmProvider: RealmProvider?
    var authenticator: Authenticator?
    var networkManager: NetworkManager?
    var syncRecordService: SyncRecordService?
    var eventStore: EKEventStore?
    static var targetEvent: EKEvent?
    var operationQueue: OperationQueue?

    override func setUp() {
        super.setUp()
        if CalendarEventTests.targetEvent != nil {
            CalendarEventTests.targetEvent?.refresh()
        }
        JPSimulatorHacks.grantAccessToCalendar()
        realmProvider = RealmProvider()
        authenticator = Authenticator(sessionManager: SessionManager.default,
                                      requestBuilder: URLRequestBuilder(deviceID: deviceID))

        networkManager = NetworkManager(authenticator: authenticator!)
        syncRecordService = SyncRecordService(realmProvider: realmProvider!)
        eventStore = EKEventStore.shared

        login()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            eventStore = EKEventStore.shared
            break
        default:
            break
        }
        operationQueue = OperationQueue()
        operationQueue?.maxConcurrentOperationCount = 1
    }
    
    override func tearDown() {
        realmProvider = nil
        authenticator = nil
        networkManager = nil
        syncRecordService = nil
        eventStore = nil
        operationQueue = nil
        super.tearDown()
    }
    
    func test001AddEvent() {
        CalendarEventTests.targetEvent = addEvent(withTitle:  "QOT CalenarEventTest test001AddEvent")
        importChanges()
        sync()
        let targetEventIdentifier = CalendarEventTests.targetEvent?.calendarItemExternalIdentifier
        
        do {
            let realm = try realmProvider?.realm()
            let expectedObject = realm?.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier).first
            XCTAssert(expectedObject != nil)
        } catch {
            XCTFail()
        }
    }
    
    func test002UpdateEvent() {
        let newTitle = "Updated - QOT CalenarEventTest test002UpdateEvent"
        CalendarEventTests.targetEvent?.title = newTitle
        do {
            try eventStore!.save(CalendarEventTests.targetEvent!, span: .thisEvent)
            print("saved title update.")
        } catch {
            //error handling here...
            print("error to update calendar event")
            XCTFail()
        }
        importChanges()
        sync()
        
        let targetEventIdentifier = CalendarEventTests.targetEvent?.calendarItemExternalIdentifier
        do {
            let realm = try realmProvider?.realm()
            let expectedObject = realm!.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier).first
            print(expectedObject!.title!)
            print(newTitle)
            XCTAssert(expectedObject!.title! ==  newTitle)
            XCTAssert(expectedObject!.event!.title ==  newTitle)
        } catch {
            XCTFail()
        }
        
    }
    
    func test003RemoveEvent() {
        let targetEventIdentifier = CalendarEventTests.targetEvent?.calendarItemExternalIdentifier

        remove(event:CalendarEventTests.targetEvent)
        importChanges()
        sync()
        
        do {
            let realm = try realmProvider?.realm()
            let expectedObject = realm?.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier).first
            XCTAssertNil(expectedObject)
        } catch {
            XCTFail()
        }
        
        CalendarEventTests.targetEvent = nil
    }
    
    func test004AddEventUpSyncRemoveFromLocalDownSync() {
        do {
            let realm = try realmProvider?.realm()
            let eventTitle = String(format: "QOT CalenarEventTest test004AddEventUpSyncRemoveFromLocal %@", Date().longDateShortTime)
            let calendarEvent = addEvent(withTitle: eventTitle)
            calendarEvent?.refresh()
            let targetEventIdentifier = calendarEvent?.calendarItemExternalIdentifier
            importChanges()
            let importedObject = realm?.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier).first
            XCTAssertNotNil(importedObject)
            sync()

            let expectedObject = realm?.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier).first
            XCTAssert(expectedObject != nil)

            try realm?.write {
                realm?.delete(expectedObject!)
            }

            let deletedObject = realm?.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier).first
            XCTAssertNil(deletedObject)

            let objects = realm?.objects(CalendarEvent.self)
            print(objects!)
            print(targetEventIdentifier!)
            
            let backendUpdateTimingExpectation = XCTestExpectation.init(description: "Waiting for backend update.....")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                backendUpdateTimingExpectation.fulfill()
            }
            wait(for: [backendUpdateTimingExpectation], timeout: 5.1)
            importChanges()
            sync()

            let syncedObjects = realm?.objects(CalendarEvent.self).filter(externalIdentifier: targetEventIdentifier!)
            XCTAssert(syncedObjects?.count == 1)
            print(syncedObjects!)
            let syncedEntity = syncedObjects?.first
            XCTAssertNotNil(syncedEntity)

            remove(event:calendarEvent)
            importChanges()
            sync()
            
        } catch {
            XCTFail()
        }
    }
    
    // MARK: - Internal -
    func addEvent(withTitle title:String!) -> EKEvent? {
        let newEvent = EKEvent.init(eventStore: eventStore!)
        newEvent.title = title
        newEvent.startDate = Date()
        newEvent.endDate = Date(timeIntervalSinceNow: 3600)
        newEvent.location = "QOT BERLIN OFFICE"
        newEvent.calendar = eventStore!.defaultCalendarForNewEvents
        
        do {
            try eventStore!.save(newEvent, span: .thisEvent)
            print("events added to \(newEvent.calendar.title)")
        } catch let e as NSError {
            print(e.description)
            XCTAssert(false)
            return nil
        }
        
        let predicate = eventStore!.predicateForEvents(withStart: Date.init(timeIntervalSinceNow: -3600),
                                                       end: Date.init(timeIntervalSinceNow: 3600),
                                                       calendars: nil)
        let savedEvents = eventStore!.events(matching: predicate)
        
        for event in savedEvents {
            if newEvent.title == event.title {
                return event
            }
        }
        return nil
    }
    
    func remove(event: EKEvent?) {
        guard let targetEvent = event else {
            return
        }
        let predicate = eventStore!.predicateForEvents(withStart: Date.init(timeIntervalSinceNow: -3600),
                                                       end: Date.init(timeIntervalSinceNow: 3600),
                                                       calendars: nil)
        let savedEvents = eventStore!.events(matching: predicate)

        for event in savedEvents {
            if targetEvent.calendarItemExternalIdentifier == event.calendarItemExternalIdentifier {
                do {
                    try eventStore!.remove(event, span: .thisEvent)
                } catch {
                    print("Error on Delete")
                }
            }
        }
    }
    
    func importChanges() {
            let day: TimeInterval = 60 * 60 * 24
            let start = Date().addingTimeInterval(-(day * 30))
            let end = Date().addingTimeInterval(day * 30)
            let task = CalendarImportTask(startDate: start, endDate: end, realmProvider: realmProvider!)
            let result = task.sync(calendars: eventStore!.calendars(for: .event))
            for calendar in eventStore!.calendars(for: .event) {
                print (calendar)
                print (calendar.calendarIdentifier)
                print (calendar.source)
            }
            print("\(result)")
    }
    
    func sync (shouldUpload: Bool = true, shouldDownload: Bool = true) {
        let syncExpectation = XCTestExpectation.init(description: "Event Sync Operation Expectation!!")
        let context = SyncContext()
        let syncOperation = self.syncOperation(context: context, shouldUpload: shouldUpload, shouldDownload: shouldDownload)
        let finishOperation = BlockOperation {
            DispatchQueue.main.async {
                syncExpectation.fulfill()
            }
        }
        finishOperation.addDependency(syncOperation)
        operationQueue?.addOperations([syncOperation, finishOperation], waitUntilFinished: false)
        
        self.wait(for: [syncExpectation], timeout: 20)
    }
    
    func syncOperation(context: SyncContext, shouldUpload: Bool, shouldDownload: Bool) -> SyncOperation {
            let upSyncTask: UpSyncTask<CalendarEvent>?
            if shouldUpload == true {
                upSyncTask = UpSyncTask<CalendarEvent>(networkManager: networkManager!, realmProvider: realmProvider!)
            } else {
                upSyncTask = nil
            }

            let downSyncTask: DownSyncTask<CalendarEvent>?
            if shouldDownload == true {
                downSyncTask = DownSyncTask<CalendarEvent>(networkManager: networkManager!,
                                                           realmProvider: realmProvider!,
                                                           syncRecordService: syncRecordService!)
            } else {
                downSyncTask = nil
            }
            return SyncOperation(upSyncTask: upSyncTask,
                                 downSyncTask: downSyncTask,
                                 syncContext: context,
                                 debugIdentifier: String(describing: CalendarEvent.self))
    }
    
    func login() {
        let loginExpectation = XCTestExpectation.init(description: "Waiting for login.....")
        authenticator?.authenticate(username: "m.karbe@tignum.com", password: "Tignum@1234", completion: { (result) in
          loginExpectation.fulfill()
        })
        
        self.wait(for: [loginExpectation], timeout: 20)
    }
}
