//
//  GuidedTrackSectionCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class GuidedTrackSectionCell: BaseDailyBriefCell {
    @IBOutlet weak var headerView: UIView!
    var baseView: QOTBaseHeaderView?
    @IBOutlet weak var button: AnimatedButton!
    var trackState = false

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        baseView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(button)
    }

    @IBAction func clickAction(_ sender: Any) {
        trackState = !trackState
        button.flipImage(trackState)
        NotificationCenter.default.post(name: .displayGuidedTrackRows, object: nil)
    }

    func configure(with: GuidedTrackViewModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        baseView?.configure(title: model.bucketTitle, subtitle: model.content)
        button.setTitle(model.buttonText, for: .normal)
    }
}
