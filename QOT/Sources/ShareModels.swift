//
//  ShareModels.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct Share {
    struct EmailContent {
        let email: String
        let subject: String
        let body: String
    }

    struct ContentItem {
        let title: String
        let url: String
        let body: String
    }
}
