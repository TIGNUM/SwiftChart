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

    // MARK: - Init
    init() { /**/ }

    func getVideoItem(type: Explanation.Types, _ completion: @escaping (QDMContentItem?) -> Void) {
        switch type {
        case .ratingOwner:
            ContentService.main.getContentItemById(110114, completion)
        case .tbvPollOwner:
            ContentService.main.getContentItemById(110113, completion)
        default:
            ContentService.main.getContentItemById(0, completion)
        }
    }
}
