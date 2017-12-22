//
//  SlideShowPromptCell.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol SlideShowPromtCellDelegate: class {

    func didTapDone(cell: UICollectionViewCell)
    func didTapMore(cell: UICollectionViewCell)
}

final class SlideShowMorePromptCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    weak var delegate: SlideShowPromtCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }

    func configure(title: String, subtitle: String, doneButtonTitle: String, moreButtonTitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 1,
                                                       font: .simpleFont(ofSize: 16),
                                                       lineSpacing: 1,
                                                       textColor: .white,
                                                       alignment: .center,
                                                       lineBreakMode: .byWordWrapping)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 1,
                                                          font: .simpleFont(ofSize: 14),
                                                          lineSpacing: 1,
                                                          textColor: .white,
                                                          alignment: .center,
                                                          lineBreakMode: .byWordWrapping)
        doneButton.setup(title: doneButtonTitle, color: .doneButton)
        moreButton.setup(title: moreButtonTitle, color: .moreButton)
    }

    @objc func didTapDoneButton() {
        delegate?.didTapDone(cell: self)
    }

    @objc func didTapMoreButton() {
        delegate?.didTapMore(cell: self)
    }
}

class SlideShowCompletePromptCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    weak var delegate: SlideShowPromtCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }

    func configure(title: String, doneButtonTitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 1,
                                                       font: .simpleFont(ofSize: 16),
                                                       lineSpacing: 1,
                                                       textColor: .white,
                                                       alignment: .center,
                                                       lineBreakMode: .byWordWrapping)
        doneButton.setup(title: doneButtonTitle, color: .doneButton)
    }

    @objc func didTapDoneButton() {
        delegate?.didTapDone(cell: self)
    }
}

private extension UIColor {

    static var doneButton = UIColor(red: 0, green: 0.58, blue: 1, alpha: 1)
    static var moreButton = UIColor.gray
}

private extension UIButton {

    func setup(title: String, color: UIColor) {
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        let attributedTitle = NSAttributedString(string: title,
                                                 font: .bentonBookFont(ofSize: 16),
                                                 textColor: color,
                                                 alignment: .center)
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
