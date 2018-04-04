//
//  PreparationAnswer.swift
//  QOT
//
//  Created by karmic on 03.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class PreparationAnswer: Object {

    @objc dynamic var answer: String = ""

    @objc dynamic var contentItemID: Int = 0

    @objc dynamic var preparationID: String = ""

    convenience init(answer: String, contentItemID: Int, preparationID: String) {
        self.init()
        self.answer = answer
        self.contentItemID = contentItemID
        self.preparationID = preparationID
    }
}

extension PreparationAnswer {

    public func toJSON() -> JSON {
        let dict: [JsonKey: JSONEncodable] = [.contentItemId: contentItemID, .answer: answer]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
