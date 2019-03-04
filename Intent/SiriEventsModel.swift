//
//  SiriEventsModel.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 01.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct SiriEventsModel: Codable {
    
    var events: [Event]
    
    struct Event: Codable {
        let date: Date
        let key: String
    }
}
