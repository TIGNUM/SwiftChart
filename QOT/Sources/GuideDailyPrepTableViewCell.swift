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
}

final class GuideDailyPrepTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var loadLabel: UILabel!
    @IBOutlet private weak var recoveryLabel: UILabel!
    @IBOutlet private weak var loadProgressView: GuideProgressView!
    @IBOutlet private weak var recoveryProgressView: GuideProgressView!
    @IBOutlet private weak var loadLabelsContainerView: UIView!
    @IBOutlet private weak var recoveryLabelsContainerView: UIView!
    @IBOutlet private weak var nullStateLabel: UILabel!
	@IBOutlet private weak var receiveFeedbackButton: UIButton!
	weak var delegate: GuideDailyPrepTableViewCellDelegate?
	var itemTapped: Guide.Item?

    override func awakeFromNib() {
        super.awakeFromNib()

        statusView.maskPathByRoundingCorners()
        containerView.corner(radius: 8)
        receiveFeedbackButton.corner(radius: 4)
        receiveFeedbackButton.backgroundColor = .azure
		receiveFeedbackButton.showsTouchWhenHighlighted = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        typeLabel.attributedText = nil
        feedbackLabel.attributedText = nil
    }

    func configure(type: String?,
                   dailyPrepFeedback: String?,
                   dailyPrepItems: [Guide.DailyPrepItem],
                   status: Guide.Item.Status) {
        titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                   text: "DAILY PREP MINUTE",
                                                   font: Font.H4Identifier,
                                                   textColor: .white,
                                                   alignment: .left)

        if let type = type {
            typeLabel.isHidden = false
            typeLabel.attributedText = attributedText(letterSpacing: 2,
                                                      text: type.uppercased(),
                                                      font: Font.H7Tag,
                                                      textColor: .white40,
                                                      alignment: .left)
        }

        if let feedback = dailyPrepFeedback {
            feedbackLabel.isHidden = false
            feedbackLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                         text: feedback,
                                                         font: Font.DPText,
                                                         lineSpacing: 6,
                                                         textColor: .white70,
                                                         alignment: .left)
        }

        nullStateLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                       text: R.string.localized.guideDailyPrepNotFinishedFeedback(),
                                                       font: Font.DPText,
                                                       lineSpacing: 6,
                                                       textColor: .white70,
                                                       alignment: .left)

        loadLabel.attributedText = attributedText(letterSpacing: 1,
                                                  text: "LOAD",
                                                  font: Font.H4Identifier,
                                                  textColor: .white,
                                                  alignment: .left)

        recoveryLabel.attributedText = attributedText(letterSpacing: 1,
                                                      text: "RECOVERY",
                                                      font: Font.H4Identifier,
                                                      textColor: .white,
                                                      alignment: .left)

        syncViews(status: status, dailyPrepItems: dailyPrepItems)
        statusView.backgroundColor = status.statusViewColor
        containerView.backgroundColor = status.cardColor
    }

    @IBAction func didTapButton(_ sender: UIButton) {
		guard let item = itemTapped else { return }
		delegate?.didTapFeedbackButton(for: item)
	}
}

// MARK: - Private

private extension GuideDailyPrepTableViewCell {

    func attributedText(letterSpacing: CGFloat = 2,
                        text: String,
                        font: UIFont,
                        lineSpacing: CGFloat = 1.4,
                        textColor: UIColor,
                        alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         letterSpacing: letterSpacing,
                                         font: font,
                                         lineSpacing: lineSpacing,
                                         textColor: textColor,
                                         alignment: alignment,
                                         lineBreakMode: .byWordWrapping)
    }

    func invertedValue(for value: Float) -> Float {
        return (10 - value) / 10
    }

    func syncViews(status: Guide.Item.Status, dailyPrepItems: [Guide.DailyPrepItem]) {
        let isHidden: Bool = status == .todo ? true : false
        loadLabel.isHidden = isHidden
        loadProgressView.isHidden = isHidden
        loadLabelsContainerView.isHidden = isHidden
        recoveryLabel.isHidden = isHidden
        recoveryProgressView.isHidden = isHidden
        recoveryLabelsContainerView.isHidden = isHidden
        feedbackLabel.isHidden = isHidden
        typeLabel.isHidden = isHidden
        nullStateLabel.isHidden = !isHidden
        receiveFeedbackButton.isHidden = !isHidden

        switch status {
        case .todo:
			return
        case .done:
            enableProgressViews(dailyPrepItems: dailyPrepItems)
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

        setGradient(in: loadProgressView, with: [UIColor.green, UIColor.red])
        setGradient(in: recoveryProgressView, with: [UIColor.red, UIColor.green])
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

// MARK: - GuideProgressView

final class GuideProgressView: UIProgressView {

    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow(color: .white, opacity: 0.2, offSet: .zero, radius: 6, scale: true)

        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
