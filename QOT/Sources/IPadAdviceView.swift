//
//  IPadAdviceView.swift
//  QOT
//
//  Created by karmic on 13.09.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol IPadAdviceViewDelegate: class {
    func dismiss()
}

enum IPadAdviceViewType: String {
    case title = "ipad.advice.title"
    case body = "ipad.advice.body"
    case buttonDismiss = "ipad.advice.button.title.dismiss"
    case buttonDoNotShowAgain = "ipad.advice.button.title.do.not.show.again"

    func value(contentService: ContentService?) -> String? {
        return contentService?.iPadAdviceValue(for: self)
    }
}

final class IPadAdviceView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var doNotShowAgainButton: UIButton!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var topHorizontalDivider: UIView!
    @IBOutlet private weak var bottomHorizontalDivider: UIView!
    weak var delegate: IPadAdviceViewDelegate?

    // MARK: - Life Cycle

    func setupView(title: String, body: String, buttonTitleDismiss: String, buttonTitleDoNotShow: String) {
        setupLabels(title: title, body: body)
        setupButtons(buttonTitleDismiss: buttonTitleDismiss, buttonTitleDoNotShow: buttonTitleDoNotShow)
        setupBackground()
    }
}

// MARK: - Setup

private extension IPadAdviceView {

    func setupBackground() {
        backgroundView.corner(radius: Layout.CornerRadius.eight.rawValue)
        backgroundView.backgroundColor = .whiteLight12
        topHorizontalDivider.backgroundColor = .whiteLight12
        bottomHorizontalDivider.backgroundColor = .whiteLight12
    }

    func setupLabels(title: String, body: String) {
        titleLabel.attributedText = attributedString(textColor: .white,
                                                     string: title,
                                                     font: .apercuBold(ofSize: 16))
        contentLabel.attributedText = attributedString(textColor: .white,
                                                       string: body,
                                                       font: .apercuRegular(ofSize: 14))
    }

    func setupButtons(buttonTitleDismiss: String, buttonTitleDoNotShow: String) {
        dismissButton.setAttributedTitle(attributedString(textColor: .azure,
                                                          string: buttonTitleDismiss,
                                                          font: .apercuMedium(ofSize: 16)), for: .normal)
        doNotShowAgainButton.setAttributedTitle(attributedString(textColor: .azure,
                                                                 string: buttonTitleDoNotShow,
                                                                 font: .apercuMedium(ofSize: 16)), for: .normal)
    }

    func attributedString(textColor: UIColor, string: String, font: UIFont) -> NSAttributedString {
        return NSAttributedString(string: string,
                                  letterSpacing: 0.8,
                                  font: font,
                                  lineSpacing: 6,
                                  textColor: textColor,
                                  alignment: .center)
    }
}

// MARK: - Actions

private extension IPadAdviceView {

    @IBAction func didTapDismissButton() {
        delegate?.dismiss()
    }

    @IBAction func didTapDoNotShowAgainButton() {
        UserDefault.iPadAdviceDoNotShowAgain.setBoolValue(value: true)
        delegate?.dismiss()
    }
}
