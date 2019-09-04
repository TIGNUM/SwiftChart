//
//  BaseDailyBriefCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class BaseDailyBriefCell: UITableViewCell, Dequeueable {
    var markSeenTimer: Timer = Timer()

    func setTimer(with timeInterval: TimeInterval, completion: @escaping() -> Void) {
        markSeenTimer = Timer.init(timeInterval: timeInterval, repeats: false, block: { _ in
            completion()
        })
        markSeenTimer.fire()
    }
}
