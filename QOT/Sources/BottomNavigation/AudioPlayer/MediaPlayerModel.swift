//
//  MediaPlayerModel.swift
//  QOT
//
//  Created by Sanggeon Park on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MediaPlayerModel {
    let title: String
    let subtitle: String
    let url: URL?
    let totalDuration: Double
    let progress: Float
    let currentTime: Double
    let mediaRemoteId: Int
}
