//
//  NegativeToPositiveTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class NegativeToPositiveTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var lowTitleLabel: UILabel!
    @IBOutlet private weak var lowFirstItemLabel: UILabel!
    @IBOutlet private weak var lowSecondItemLabel: UILabel!
    @IBOutlet private weak var lowThirdItemLabel: UILabel!
    @IBOutlet private weak var highTitleLabel: UILabel!
    @IBOutlet private weak var highFirstItemLabel: UILabel!
    @IBOutlet private weak var highSecondItemLabel: UILabel!
    @IBOutlet private weak var highThirdItemLabel: UILabel!
    @IBOutlet private weak var highPerformanceView: UIView!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

// MARK: - Configuration

extension NegativeToPositiveTableViewCell {

    func configure(title: String, lowTitle: String, lowItems: [String], highTitle: String, highItems: [String]) {
        titleLabel.text = title
        lowTitleLabel.text = lowTitle
        lowFirstItemLabel.text = lowItems[0]
        lowSecondItemLabel.text = lowItems[1]
        lowThirdItemLabel.text = lowItems[2]
        highTitleLabel.text = highTitle
        highFirstItemLabel.text = highItems[0]
        highSecondItemLabel.text = highItems[1]
        highThirdItemLabel.text = highItems[2]
    }
}

// MARK: - Private

extension NegativeToPositiveTableViewCell {

    func setupView() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(syncHighPerformanceView(_:)))
        highPerformanceView.layer.shadowOpacity = 0.2
        highPerformanceView.layer.shadowRadius = 5
        highPerformanceView.layer.shadowOffset = CGSize(width: -10, height: 0)
        highPerformanceView.addGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - GestureRecognizer

private extension NegativeToPositiveTableViewCell {

    @objc func syncHighPerformanceView(_ gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.translation(in: self)
        if point.x > -(bounds.width * 0.4) && point.x < bounds.width * 0.4 {
            UIView.animate(withDuration: Animation.duration_02) {
                self.leadingConstraint.constant = point.x
                self.layoutIfNeeded()
            }
        }
    }
}
