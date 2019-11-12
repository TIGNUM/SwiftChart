//
//  GuidedTrackRowCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class GuidedTrackRowCell: BaseDailyBriefCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subtitle: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet private weak var watchButton: AnimatedButton!
    @IBOutlet private weak var showMoreButton: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var appLink: QDMAppLink?
    @IBOutlet weak var dividerView: UIView!
    var trackState = false

    override func awakeFromNib() {
        super.awakeFromNib()
        watchButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        showMoreButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addTitle(title)
        skeletonManager.addSubtitle(subtitle)
        skeletonManager.addSubtitle(content)
        skeletonManager.addOtherView(watchButton)
    }

    func configure(with: GuidedTrackViewModel?, _ hideDivider: Bool) {
        guard let model = with else { return }
        skeletonManager.hide()
        title.text = model.bucketTitle
        subtitle.text = model.levelTitle
        content.text = model.content
        appLink = model.appLink
        watchButton.setTitle(model.buttonText, for: .normal)
        dividerView.isHidden = hideDivider
        showMoreButton.isHidden = with?.type != .FIRSTROW
    }

    @IBAction func didTapShowMore(_ sender: Any) {
        trackState = !trackState
        showMoreButton.flipImage(trackState)
        NotificationCenter.default.post(name: .displayGuidedTrackRows, object: nil)
    }

    @IBAction func didTapWatch() {
        delegate?.openGuidedTrackAppLink(appLink)
    }
}
