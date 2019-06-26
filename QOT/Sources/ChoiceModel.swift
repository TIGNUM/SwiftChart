//
//  ChoiceModel.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Choice {
    let categoryName: String
    let contentId: Int
    let title: String
    let readingTime: String
    let isDefault: Bool
    let isSuggested: Bool
    var selected: Bool
}
