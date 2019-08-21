//
//  GuidedTrackSectionCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class GuidedTrackSectionCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBAction func clickAction(_ sender: Any) {
        NotificationCenter.default.post(name: .displayGuidedTrackCells, object: nil)
    }

    func configure(with: GuidedTrackSectionViewModel?) {
        title.text = with?.bucketTitle
        content.text = with?.content
        button.setTitle(with?.buttonText, for: .normal)
    }
}
