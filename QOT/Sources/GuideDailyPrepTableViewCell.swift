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
    weak var delegate: GuideDailyPrepTableViewCellDelegate?
	var itemTapped: Guide.Item?

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
        nullStateQuestionLabel.font = .apercuBold(ofSize: 16)
        titleLabel.text = R.string.localized.morningControllerTitleLabel()
        nullStateLabel.attributedText = bodyAttributedText(text: R.string.localized.guideDailyPrepNotFinishedFeedback(),
                                                           font: .ApercuRegular15)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        feedbackLabel.attributedText = nil
    }

    // MARK: - Cell configuration

    func configure(dailyPrepFeedback: String?,
                   dailyPrepItems: [Guide.DailyPrepItem],
                   status: Guide.Item.Status) {
        if let feedback = dailyPrepFeedback {
            feedbackLabel.isHidden = false
            feedbackLabel.attributedText = bodyAttributedText(text: feedback, font: .ApercuRegular15)
        }
        loadLabel.textColor = status == .todo ? .dailyPrepNullStateGray : .white
        recoveryLabel.textColor = status == .todo ? .dailyPrepNullStateGray : .white
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
        syncStatusView(with: status,
                       for: statusView,
                       firstConstraint: titleTopConstraintToStatus,
                       secondConstraint: titleTopConstraintToSuperview)
        syncViews(status: status, dailyPrepItems: dailyPrepItems)
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
        recoveryProgressView.type = .recovery
        loadProgressView.type = .load
        switch status {
        case .todo:
            loadProgressView.trackImage = nil
            recoveryProgressView.trackImage = nil
            loadProgressView.progressTintColor = .dailyPrepNullStateGray
            recoveryProgressView.progressTintColor = .dailyPrepNullStateGray
            loadLabelsContainer.subviews.forEach { ($0 as? UILabel)?.textColor = .dailyPrepNullStateGray }
            recoveryLabelsContainer.subviews.forEach { ($0 as? UILabel)?.textColor = .dailyPrepNullStateGray }
            loadProgressView.startNullStateAnimation()
            recoveryProgressView.startNullStateAnimation()
        case .done:
            setGradient(in: loadProgressView, with: [.recoveryGreen, .recoveryRed])
            setGradient(in: recoveryProgressView, with: [.recoveryRed, .recoveryGreen])
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

    func setGradient(in progressView: UIProgressView, with colors: [UIColor]) {
        let gradientView = UIView(frame: progressView.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = progressView.bounds
        gradientLayer.startPoint =  CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        let gradientImage = UIImage(view: gradientView)?.withHorizontallyFlippedOrientation()
        progressView.trackImage = gradientImage
        progressView.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        progressView.progressTintColor = UIColor(red: 0.11, green: 0.22, blue: 0.31, alpha: 1.0)
    }
}
