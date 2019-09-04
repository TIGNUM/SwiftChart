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
        return qot_dal.ScreenTitleService.main.localizedString(for: .WalkthroughSwipeText)
    }()

    // MARK: - Init

    init() {
    }
}
