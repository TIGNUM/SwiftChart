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

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addTitle(title)
        skeletonManager.addSubtitle(content)
        skeletonManager.addOtherView(button)
    }

    @IBAction func clickAction(_ sender: Any) {
        trackState = !trackState
        button.flipImage(trackState)
        NotificationCenter.default.post(name: .displayGuidedTrackRows, object: nil)
    }

    func configure(with: GuidedTrackViewModel?) {
        title.text = with?.bucketTitle
        content.text = with?.content
        button.setTitle(with?.buttonText, for: .normal)
    }
}
