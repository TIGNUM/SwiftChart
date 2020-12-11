//
//  VisionRatingExplanationWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class VisionRatingExplanationWorker: WorkerTeam {
    func getVideoItem(type: Explanation.Types, _ completion: @escaping (QDMContentItem?) -> Void) {
        switch type {
        case .ratingOwner,
             .ratingUser:
            ContentService.main.getContentItemById(110114, completion)
        case .tbvPollOwner,
             .tbvPollUser:
            ContentService.main.getContentItemById(110113, completion)
        case .createTeam:
            ContentService.main.getContentItemById(110402, completion)
        }
    }
}
