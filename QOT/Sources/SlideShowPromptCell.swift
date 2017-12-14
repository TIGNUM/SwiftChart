//
//  SlideShowPromptCell.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SlideShowPromptCell: UICollectionViewCell, Dequeueable {
    typealias ButtonHandler = () -> Void

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!

    private var startHandler: ButtonHandler?
    private var moreHandler: ButtonHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)

        startButton.setup(borderColor: .blue)
        moreButton.setup(borderColor: .gray)
        moreButton.isHidden = true
    }

    func configure(title: String, startHandler: @escaping ButtonHandler, moreHandler: ButtonHandler?) {
        self.titleLabel.text = title
        self.startHandler = startHandler
        self.moreHandler = moreHandler
        moreButton.isHidden = moreHandler == nil
    }

    @objc func didTapStartButton() {
        startHandler?()
    }

    @objc func didTapMoreButton() {
        moreHandler?()
    }
}

private extension UIButton {

    func setup(borderColor: UIColor) {
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
    }
}
