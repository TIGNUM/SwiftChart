//
//  BaseDailyBriefCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class BaseDailyBriefCell: UITableViewCell, Dequeueable {
    private var markAsSeenTimer: Timer?
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)
        selectionStyle = .none
    }

    func setTimer(with timeInterval: TimeInterval, completion: @escaping() -> Void) {
        if markAsSeenTimer?.isValid == true {
            return
        }
        markAsSeenTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (_) in
            self?.markAsSeenTimer?.invalidate()
            self?.markAsSeenTimer = nil
            completion()
        })
    }

    func stopTimer() {
        markAsSeenTimer?.invalidate()
        markAsSeenTimer = nil
    }
}
