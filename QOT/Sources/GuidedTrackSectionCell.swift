//
//  GuidedTrackSectionCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class GuidedTrackSectionCell: BaseDailyBriefCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet weak var button: AnimatedButton!
    var trackState = false
    @IBAction func clickAction(_ sender: Any) {
        trackState = !trackState
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.button.imageView?.transform = CGAffineTransform(scaleX: 1.0, y: self.trackState ? -1.0 : 1.0)
        }
        NotificationCenter.default.post(name: .displayGuidedTrackRows, object: nil)
    }

    func configure(with: GuidedTrackViewModel?) {
        title.text = with?.bucketTitle
        content.text = with?.content
        button.setTitle(with?.buttonText, for: .normal)
    }
}
