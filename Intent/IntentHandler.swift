//
//  IntentHandler.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Intents

final class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is ReadVisionIntent:
            return ReadVisionIntentHandler()
        case is WhatsHotIntent:
            return WhatsHotIntentHandler()
        case is UpcomingEventIntent:
            return UpcomingEventHandler()
        default:
            return self
        }
    }
}
