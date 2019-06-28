//
//  AVPlayerViewController+BottomNavigation.swift
//  QOT
//
//  Created by Sanggeon Park on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import AVKit

extension AVPlayerViewController {
    override open func viewWillAppear(_ animated: Bool) {
        // Make sure that stop playing Audio
        NotificationCenter.default.post(name: .stopAudio, object: nil)
        super.viewWillAppear(animated)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshBottomNavigationItems()
    }

    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
