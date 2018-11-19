//
//  GuideDailyPrepTableViewCell.swift
//  QOT
//
//  Created by karmic on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol GuideDailyPrepTableViewCellDelegate: class {
	func didTapFeedbackButton(for item: Guide.Item)
    func didTapInfoButton()
}

final class GuideDailyPrepTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var feedbackSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet private weak var recoveryLabel: UILabel!
    @IBOutlet private weak var loadProgressView: GuideProgressView!
    @IBOutlet private weak var recoveryProgressView: GuideProgressView!
    @IBOutlet private weak var loadLabelsContainerView: UIView!
    @IBOutlet private weak var recoveryLabelsContainerView: UIView!
    @IBOutlet private weak var nullStateLabel: UILabel!
	@IBOutlet private weak var receiveFeedbackButton: UIButton!
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var loadLabelsContainer: UIView!
    @IBOutlet private weak var recoveryLabelsContainer: UIView!
    @IBOutlet private weak var nullStateQuestionLabel: UILabel!
    @IBOutlet private weak var titleTopConstraintToStatus: NSLayoutConstraint!
    @IBOutlet private weak var titleTopConstraintToSuperview: NSLayoutConstraint!
    private var labelsColors: [UIColor] = [.recoveryGreen, .recoveryOrange, .recoveryRed]
    private var initialPositionY: CGFloat = 0
    weak var delegate: GuideDailyPrepTableViewCellDelegate?
	var itemTapped: Guide.Item? = nil

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.maskPathByRoundingCorners()
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
        receiveFeedbackButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        receiveFeedbackButton.backgroundColor = .azure
        receiveFeedbackButton.showsTouchWhenHighlighted = true
        titleLabel.font = .ApercuMedium31
        loadLabel.font = .H5SecondaryHeadline
        recoveryLabel.font = .H5SecondaryHeadline
        feedbackLabel.alpha = 0.8
        nullStateLabel.alpha = 0.8
        nullStateQuestionLabel.font = .apercuBold(ofSize: 16)
        titleLabel.text = R.string.localized.morningControllerTitleLabel()
        nullStateLabel.attributedText = bodyAttributedText(text: R.string.localized.guideDailyPrepNotFinishedFeedback(),
                                                           font: .ApercuRegular15)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        feedbackLabel.attributedText = nil
        feedbackSpinner.isHidden = true
    }

    // MARK: - Cell configuration

    func configure(dailyPrepFeedback: String?,
                   dailyPrepItems: [Guide.DailyPrepItem],
                   status: Guide.Item.Status,
                   yPosition: CGFloat) {
        if yPosition != initialPositionY {
            loadProgressView.setProgress(status == .todo ? 0 : 1, animated: false)
            recoveryProgressView.setProgress(status == .todo ? 0 : 1, animated: false)
        }
        if status == .done && dailyPrepFeedback == nil {
            feedbackSpinner.startAnimating()
            feedbackSpinner.isHidden = false
        } else {
            feedbackSpinner.stopAnimating()
            feedbackSpinner.isHidden = true
        }
        if let feedback = dailyPrepFeedback {
            feedbackLabel.isHidden = false
            feedbackLabel.attributedText = bodyAttributedText(text: feedback, font: .ApercuRegular15)
        }
        containerView.alpha = status == .todo ? 0.7 : 1
        loadLabel.textColor = status == .todo ? .dailyPrepNullStateGray : .white
        recoveryLabel.textColor = status == .todo ? .dailyPrepNullStateGray : .white
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
        syncStatusView(with: status,
                       for: statusView,
                       firstConstraint: titleTopConstraintToStatus,
                       secondConstraint: titleTopConstraintToSuperview)
        syncViews(status: status, dailyPrepItems: dailyPrepItems)
        initialPositionY = yPosition
    }
}

// MARK: - Actions

private extension GuideDailyPrepTableViewCell {

    @IBAction func didTapButton(_ sender: UIButton) {
        guard let item = itemTapped else { return }
        delegate?.didTapFeedbackButton(for: item)
    }

    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton()
    }
}

// MARK: - Private

private extension GuideDailyPrepTableViewCell {

    func invertedValue(for value: Float) -> Float {
        return (10 - value) / 10
    }

    func syncViews(status: Guide.Item.Status, dailyPrepItems: [Guide.DailyPrepItem]) {
        let isHidden: Bool = status == .todo ? true : false
        feedbackLabel.isHidden = isHidden
        nullStateLabel.isHidden = !isHidden
        receiveFeedbackButton.isHidden = !isHidden
        nullStateQuestionLabel.isHidden = !isHidden
        switch status {
        case .todo:
            loadProgressView.trackImage = nil
            recoveryProgressView.trackImage = nil
            loadProgressView.progressTintColor = .dailyPrepNullStateGray
            recoveryProgressView.progressTintColor = .dailyPrepNullStateGray
            loadLabelsContainer.subviews.forEach { ($0 as? UILabel)?.textColor = .dailyPrepNullStateGray }
            recoveryLabelsContainer.subviews.forEach { ($0 as? UILabel)?.textColor = .dailyPrepNullStateGray }
            loadProgressView.setProgress(0.3, animated: true)
            recoveryProgressView.setProgress(0.8, animated: true)
        case .done:
            loadProgressView.setGradient(with: [.recoveryGreen, .recoveryRed])
            recoveryProgressView.setGradient(with: [.recoveryRed, .recoveryGreen])
            enableProgressViews(dailyPrepItems: dailyPrepItems)
            for (index, view) in loadLabelsContainer.subviews.enumerated() {
                (view as? UILabel)?.textColor = labelsColors[index]
            }
            for (index, view) in recoveryLabelsContainer.subviews.enumerated() {
                (view as? UILabel)?.textColor = labelsColors.reversed()[index]
            }
        }
    }

    func enableProgressViews(dailyPrepItems: [Guide.DailyPrepItem]) {
        var recoveryResults: Float = 0
        var recoveryCounter: Float = 0
        var loadResults: Float = 0
        var loadCounter: Float = 0
        for item in dailyPrepItems {
            let title = item.title.lowercased()
            if title.contains("quality") || title.contains("quantity") {
                recoveryResults += Float(item.result ?? 1)
                recoveryCounter += 1
            } else if title.contains("length") || title.contains("load") || title.contains("pressure") {
                loadResults += Float(item.result ?? 1)
                loadCounter += 1
            }
        }
        loadProgressView.setProgress(invertedValue(for: loadResults / Float(loadCounter)), animated: true)
        recoveryProgressView.setProgress(invertedValue(for: recoveryResults / Float(recoveryCounter)), animated: true)
    }
}
