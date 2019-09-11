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
    @IBOutlet private weak var button: AnimatedButton!
    @IBAction func clickAction(_ sender: Any) {
        NotificationCenter.default.post(name: .displayGuidedTrackRows, object: nil)
    }

    func configure(with: GuidedTrackViewModel?) {
        title.text = with?.bucketTitle
        content.text = with?.content
        button.setTitle(with?.buttonText, for: .normal)
    }
}
