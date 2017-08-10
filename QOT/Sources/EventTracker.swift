//
//  EventTracker.swift
//  QOT
//
//  Created by Lee Arromba on 09/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class EventTracker {
    enum Event {
        case didShowPage(TrackablePage, from: TrackablePage?)
    }
    
    static let `default` = EventTracker()
    
    func track(_ event: Event) {
        switch event {
        case .didShowPage(let page, let previousPage):
            handleDidShowPage(page, from: previousPage)
        }
    }
    
    // MARK: - private
    
    private func handleDidShowPage(_ page: TrackablePage, from previousPage: TrackablePage?) {
//        var data = EventData()
//        if let lastPage = lastPage {
//            // TODO: this
//        } else {
//            // TODO: this
//        }
//        sendData(data)
    }
    
    private func sendData(_ eventData: EventData) {
        // TODO: this
    }
}
