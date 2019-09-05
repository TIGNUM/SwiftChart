//
//  TextTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TextTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var visionTextLabel: UILabel!
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!

    override func prepareForReuse() {
        super.prepareForReuse()
        dotsLoadingView.isHidden = true
    }
}

// MARK: - Configuration
extension TextTableViewCell {
    func configure(with text: String, textColor: UIColor?, showTypingAnimation: Bool) {
        visionTextLabel.textColor = textColor
        visionTextLabel.text = text
        visionTextLabel.addCharacterSpacing(0.5)
        if showTypingAnimation == true {
            dotsLoadingView.isHidden = false
            dotsLoadingView.configure(dotsColor: .carbonNew)
            dotsLoadingView.startAnimation(withDuration: Animation.duration_3) { [weak self] in
                self?.visionTextLabel.isHidden = false
            }
        } else {
            visionTextLabel.isHidden = false
        }
    }
}
