//
//  NegativeToPositiveTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class NegativeToPositiveTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var lowPerformanceView: UIView!
    @IBOutlet private weak var lowTitleLabel: UILabel!
    @IBOutlet private weak var lowFirstItemLabel: UILabel!
    @IBOutlet private weak var lowSecondItemLabel: UILabel!
    @IBOutlet private weak var lowThirdItemLabel: UILabel!
    @IBOutlet private weak var highTitleLabel: UILabel!
    @IBOutlet private weak var highFirstItemLabel: UILabel!
    @IBOutlet private weak var highSecondItemLabel: UILabel!
    @IBOutlet private weak var highThirdItemLabel: UILabel!
    @IBOutlet private weak var highPerformanceView: UIView!
    @IBOutlet private weak var highPerformanceContainerView: UIView!
    @IBOutlet private weak var highPerformanceConstraint: NSLayoutConstraint!

    private var initialOffset: CGFloat = 0
    private let singleOffset: CGFloat = 25

    lazy var leftOffset: CGFloat = { return 0 }()
    lazy var middleOffset: CGFloat = { return self.contentView.bounds.width * 0.5 - self.singleOffset }()
    lazy var rightOffset: CGFloat = { return self.contentView.bounds.width - 2 * self.singleOffset }()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if initialOffset == 0 {
            initialOffset = middleOffset
            highPerformanceConstraint.constant = initialOffset
        }
    }
}

// MARK: - Configuration
extension NegativeToPositiveTableViewCell {
    func configure(title: String, lowTitle: String, lowItems: [String], highTitle: String, highItems: [String]) {
        selectionStyle = .none

        ThemeView.tbvLowPerformance.apply(lowPerformanceView)
        ThemeText.resultTitle.apply(title, to: titleLabel)

        ThemeText.tbvQuestionLight.apply(lowTitle, to: lowTitleLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[0, default: "lowItem_01 not set"], to: lowFirstItemLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[1, default: "lowItem_02 not set"], to: lowSecondItemLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[2, default: "lowItem_03 not set"], to: lowThirdItemLabel)

        ThemeText.resultTitle.apply(highTitle, to: highTitleLabel)
        ThemeText.resultHeader2.apply(highItems[0, default: "highItem_01 not set"], to: highFirstItemLabel)
        ThemeText.resultHeader2.apply(highItems[1, default: "highItem_02 not set"], to: highSecondItemLabel)
        ThemeText.resultHeader2.apply(highItems[2, default: "highItem_03 not set"], to: highThirdItemLabel)
    }
}

// MARK: - Private
private extension NegativeToPositiveTableViewCell {
    func setupView() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(syncHighPerformanceView(_:)))
        gestureRecognizer.delegate = self
        highPerformanceContainerView.addGestureRecognizer(gestureRecognizer)
        highPerformanceView.layer.shadowOpacity = 0.2
        highPerformanceView.layer.shadowRadius = 5
        highPerformanceView.layer.shadowOffset = CGSize(width: -10, height: 0)
    }

    func endSlide(for position: CGFloat) {
        if position < (contentView.bounds.size.width * 0.25) {
            clipTo(leftOffset)
        } else if position > (contentView.bounds.size.width * 0.65) {
            clipTo(rightOffset)
        } else {
            clipTo(middleOffset)
        }
    }

    func clipTo(_ offset: CGFloat) {
        UIView.animate(withDuration: Animation.duration_04, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.highPerformanceConstraint.constant = offset
            self?.layoutIfNeeded()
        })
    }
}

// MARK: - GestureRecognizer
private extension NegativeToPositiveTableViewCell {
    @objc func syncHighPerformanceView(_ gestureRecognizer: UIPanGestureRecognizer) {
        // Remember starting position
        if gestureRecognizer.state == .began {
            initialOffset = highPerformanceConstraint.constant
        }

        // Get offset
        let point = gestureRecognizer.translation(in: self)
        let finalPosition = self.initialOffset + point.x

        // Handle end (take velocity into account to determine the end position)
        if gestureRecognizer.state == .ended {
            endSlide(for: finalPosition + gestureRecognizer.velocity(in: highPerformanceContainerView).x * 0.3)
            return
        }

        // Animate slide
        UIView.animate(withDuration: Animation.duration_02) { [weak self] in
            self?.highPerformanceConstraint.constant = finalPosition
            self?.layoutIfNeeded()
        }
    }
}

// Gesture recognizer delegate
extension NegativeToPositiveTableViewCell {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = pan.velocity(in: highPerformanceContainerView)
        return fabs(velocity.x) > fabs(velocity.y)
    }
}
