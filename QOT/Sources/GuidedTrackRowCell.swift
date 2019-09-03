//
//  GuidedTrackRowCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class GuidedTrackRowCell: BaseDailyBriefCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subtitle: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet private weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with: GuidedTrackViewModel?) {
//        title.text = with?.heading
        subtitle.text = with?.bucketTitle
        content.text = with?.content
        button.setTitle(with?.buttonText, for: .normal)
    }
}
