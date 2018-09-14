//
//  MyToBeVisionModels.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct MyToBeVisionModel {

    struct Model: Equatable {
        var headLine: String?
        var imageURL: URL?
        var lastUpdated: Date?
        var text: String?
        var needsToRemind: Bool?

        public static func == (lhs: Model, rhs: Model) -> Bool {
            return lhs.headLine == rhs.headLine
                && lhs.imageURL == rhs.imageURL
                && lhs.lastUpdated == rhs.lastUpdated
                && lhs.text == rhs.text
                && lhs.needsToRemind == rhs.needsToRemind
        }
    }
}
