//
//  FromMyCoachCellViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct FromMyCoachCellViewModel {
    let detail: FromMyCoachDetail
    let messages: [FromMyCoachMessage]
}

struct FromMyCoachDetail {
    let imageUrl: URL?
    let title: String
}

struct FromMyCoachMessage {
    let date: String
    let text: String
}
