//
//  HelpModels.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum ScreenHelp {
    struct ViewModel {
        let title: String
        let imageURL: URL?
        let videoURL: URL?
        let message: String
    }

    enum Plist {
        enum Key: String {
            // learn
            case strategies
            case whatsHot

            // me
            case myData
            case myWhy

            // prepare
            case coach
            case prep
        }

        struct Item: Codable {
            let title: String
            let imageURL: String
            let videoURL: String
            let message: String
        }

        static let name: String = "ScreenHelp"
    }
}
