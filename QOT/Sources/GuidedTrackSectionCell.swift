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

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(title)
        skeletonManager.addSubtitle(content)
    }

    @IBAction func clickAction(_ sender: Any) {

    }

    func configure(with: GuidedTrackViewModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        title.text = model.bucketTitle
        content.text = model.content
    }
}
