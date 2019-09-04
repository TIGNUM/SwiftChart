//
//  WalkthroughSearchWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class WalkthroughSearchWorker {

    // MARK: - Properties
    lazy var text: String = {
        return qot_dal.ScreenTitleService.main.localizedString(for: .WalkthroughSearchText)
    }()

    // MARK: - Init

    init() {
    }
}
