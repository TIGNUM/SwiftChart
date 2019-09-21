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
    @IBOutlet private weak var button: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var appLink: QDMAppLink?
    @IBOutlet weak var dividerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addTitle(title)
        skeletonManager.addSubtitle(subtitle)
        skeletonManager.addSubtitle(content)
        skeletonManager.addOtherView(button)
    }

    func configure(with: GuidedTrackViewModel?, _ hideDivider: Bool) {
        guard let model = with else { return }
        skeletonManager.hide()
        title.text = model.bucketTitle
        subtitle.text = model.levelTitle
        content.text = model.content
        self.appLink = model.appLink
        button.setTitle(model.buttonText, for: .normal)
        dividerView.isHidden = hideDivider
    }

    @IBAction func onGuidedTrackSelection() {
        delegate?.openGuidedTrackAppLink(appLink)
    }
}
