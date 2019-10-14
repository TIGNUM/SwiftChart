//
//  WalkthroughSwipeWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class WalkthroughSwipeWorker {

    // MARK: - Properties
    lazy var text: String = {
        return AppTextService.get(AppTextKey.walkthrough_view_swipe_title)
    }()

    // MARK: - Init

    init() {
    }
}
