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
    var delegate: DailyBriefViewControllerDelegate?
    private var appLink: QDMAppLink?
    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with: GuidedTrackViewModel?) {
        title.text = with?.bucketTitle
        subtitle.text = with?.levelTitle
        content.text = with?.content
        self.appLink = with?.appLink
        button.setTitle(with?.buttonText, for: .normal)
    }

    @IBAction func onGuidedTrackSelection() {
        delegate?.openGuidedTrackAppLink(appLink)
    }
}
