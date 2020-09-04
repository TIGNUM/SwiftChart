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

    func getVideoItem(_ completion: @escaping (QDMContentItem?) -> Void) {
        ContentService.main.getContentItemById(0, completion)
    }
}
