//
//  CalendarImportTaskTests.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import XCTest
import RealmSwift
import EventKit
@testable import QOT

class CalendarImportTaskTests: XCTestCase {
    private let eventStore = MockEventStore()
    private let sut = CalendarImportTask()
    
    func test_sync_withEventsInRealmNotInEventStore_softDeletesEventsInRealm() {
        //Arrange
        let realm = Realm.inMemory()
        
        // Setup events in store
        var inStore: [CalendarEvent] = []
        for _ in 0..<3 {
            let eventData = MockCalendarEventData()
            eventStore.addEvent(eventData)
            inStore.append(CalendarEvent(event: eventData))
        }
        
        // Setup events not in store
        var notInStore: [CalendarEvent] = []
        for _ in 0..<3 {
            notInStore.append(CalendarEvent(event: MockCalendarEventData()))
        }
        
        try! realm.write {
            realm.add(inStore)
            realm.add(notInStore)
        }
        
        // Act
        let result = sut.sync(events: [], realm: realm, store: eventStore)
        
        // Assert
        switch result {
        case .success:
            let events = realm.objects(CalendarEvent.self)
            XCTAssertEqual(events.count, inStore.count + notInStore.count, "Events should only be soft deleted")
            
            let softDeleted = events.filter { $0.deleted }
            let notDeleted = events.filter { !$0.deleted }
            XCTAssertEqual(Set(softDeleted), Set(notInStore))
            XCTAssertEqual(Set(notDeleted), Set(inStore))
        case .failure(let error):
            XCTFail("unexpectedly failed: \(error)")
        }
    }
    
    func test_sync_withEventsInEventStoreNotInRealm_createsEventsInRealm() {
        // Arrange
        let realm = Realm.inMemory()
        let maria = MockCalendarEventParticipantData(name: "Maria")
        let alexa = MockCalendarEventParticipantData(name: "Alexa")
        let event = MockCalendarEventData(participants: [maria, alexa])
        eventStore.addEvent(event)
        
        // Act
        let result = sut.sync(events: [event], realm: realm, store: eventStore)
        
        // Assert
        switch result {
        case .success:
            let realmEvent = realm.object(ofType: CalendarEvent.self, forPrimaryKey: event.id)!
            XCTAssert(calendarEvent(realmEvent, containsCorrectData: event))
        case .failure(let error):
            XCTFail("unexpectedly failed: \(error)")
        }
    }
    
    func test_sync_withUpdatedEventsInEventStoreNotUpdatedInRealm_updatesEventsInRealm() {        
        // Arrange
        let realm = Realm.inMemory()
        let original = Date()
        
        let eventA = MockCalendarEventData(id: "A", title: "A", modified: original)
        eventA.participantsData = [
            MockCalendarEventParticipantData(name: "Maria"),
            MockCalendarEventParticipantData(name: "Alexa")
        ]
        
        let eventBTitle = "B"
        let eventBParticipants = [
            MockCalendarEventParticipantData(name: "Nelson"),
            MockCalendarEventParticipantData(name: "Buddy")
        ]
        let eventB = MockCalendarEventData(id: "B", title: eventBTitle, modified: original)
        eventB.participantsData = eventBParticipants
        
        eventStore.addEvent(eventA)
        eventStore.addEvent(eventB)
        
        try! realm.write {
            realm.add([CalendarEvent(event: eventA), CalendarEvent(event: eventB)])
        }
        
        // Update event A and set later modified time
        eventA.title = "A updated"
        eventA.participantsData = [
            MockCalendarEventParticipantData(name: "Beww"),
        ]
        eventA.modified = Date(timeInterval: 1, since: original)
        
        // Update event B but DON'T set later modified time
        eventB.title = "B updated"
        eventB.participantsData = [MockCalendarEventParticipantData(name: "Lego")]
    
        // Act
        let result = sut.sync(events: [eventA, eventB], realm: realm, store: eventStore)
        
        // Assert
        switch result {
        case .success:
            // Assert realmEventA updated
            let realmEventA = realm.object(ofType: CalendarEvent.self, forPrimaryKey: eventA.id)!
            XCTAssert(calendarEvent(realmEventA, containsCorrectData: eventA))
            
            // Assert realmEventB not updated
            let realmEventB = realm.object(ofType: CalendarEvent.self, forPrimaryKey: eventB.id)!
            XCTAssert(!calendarEvent(realmEventB, containsCorrectData: eventB))
            XCTAssertEqual(realmEventB.title, eventBTitle)
            XCTAssertEqual(realmEventB.participants.count, eventBParticipants.count)
            
        case .failure(let error):
            XCTFail("unexpectedly failed: \(error)")
        }
    }
    
    private func calendarEvent(_ calendarEvent: CalendarEvent, containsCorrectData data: CalendarEventData) -> Bool {
        guard calendarEvent.participantsData.count == data.participantsData.count else {
            return false
        }
        
        for i in 0..<calendarEvent.participantsData.count {
            let left = calendarEvent.participantsData[i]
            let right = data.participantsData[i]
            
            if !(left.name == right.name && left.isCurrentUser == right.isCurrentUser && left.type == right.type) {
                return false
            }
        }

        return calendarEvent.id == data.id
            && calendarEvent.title == data.title
            && calendarEvent.location == data.location
            && calendarEvent.notes == data.notes
            && calendarEvent.modified == data.modified
            && calendarEvent.timeZoneID == data.timeZoneID
            && calendarEvent.isAllDay == data.isAllDay
            && calendarEvent.startDate == data.startDate
            && calendarEvent.endDate == data.endDate
            && calendarEvent.deleted == data.deleted
            && calendarEvent.status == data.status
            && calendarEvent.coordinate?.latitude == data.coordinate?.latitude
            && calendarEvent.coordinate?.longitude == data.coordinate?.longitude
    }
}
