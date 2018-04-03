//
//  PreparationAnswer.swift
//  QOT
//
//  Created by karmic on 03.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class PreparationAnswer: Object {

    @objc dynamic var answer: String = ""

    @objc dynamic var contentItemID: Int = 0
}

