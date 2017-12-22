//
//  GuideGreetingView.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

var guideDate = Date()

final class GuideGreetingView: UIView {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var hourStepper: UIStepper!
    @IBOutlet private weak var dayStepper: UIStepper!
    @IBOutlet private weak var guideDateLabel: UILabel!
    var viewModel: GuideViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        let calendar = Calendar.sharedUTC
        var components = DateComponents(calendar: calendar)
        hourStepper.value = Double(components.hour ?? 12)
        dayStepper.value = Double(components.day ?? 15)
        backgroundColor = .pineGreen
        guideDateLabel.text = shortDateFormatter.string(from: guideDate)
    }

    func updateGuideTime(hoursFromNow: Int) {
        let calendar = Calendar.sharedUTC
        var components = DateComponents()
        components.hour = hoursFromNow
        guideDate = calendar.date(byAdding: components, to: guideDate)!
        guideDateLabel.text = shortDateFormatter.string(from: guideDate)
        viewModel?.createTodaysGuideIfNeeded()
        viewModel?.reload()
            //Calendar.sharedUTC.dateComponents([.hour], from: guideDate).description
    }

    func updateGuideDate(daysFromNow: Int) {
        let calendar = Calendar.sharedUTC
        var components = DateComponents()
        components.day = daysFromNow
        guideDate = calendar.date(byAdding: components, to: guideDate)!
        guideDateLabel.text = shortDateFormatter.string(from: guideDate)
        viewModel?.createTodaysGuideIfNeeded()
        viewModel?.reload()
            //Calendar.sharedUTC.dateComponents([.day], from: guideDate).description
    }

    func configure(_ message: String, _ greeting: String) {
        messageLabel.attributedText = attributedText(letterSpacing: 0.2,
                                                     text: message,
                                                     font: Font.H5SecondaryHeadline,
                                                     textColor: .white70,
                                                     alignment: .left)
        greetingLabel.attributedText = attributedText(letterSpacing: -0.8,
                                                      text: greeting,
                                                      font: Font.H4Headline,
                                                      textColor: .white,
                                                      alignment: .left)
        greetingLabel.sizeToFit()
        layoutSubviews()
    }
}

private let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

// MARK: - Actions

extension GuideGreetingView {

    @IBAction func hourDidChangeValue(sender: UIStepper) {
        updateGuideTime(hoursFromNow: sender.stepValue.toInt)
    }

    @IBAction func dayDidChangeValue(sender: UIStepper) {
        updateGuideDate(daysFromNow: sender.stepValue.toInt)
    }
}

// MARK: - Private

private extension GuideGreetingView {

    func attributedText(letterSpacing: CGFloat = 2,
                        text: String,
                        font: UIFont,
                        textColor: UIColor,
                        alignment: NSTextAlignment) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text,
                                         letterSpacing: letterSpacing,
                                         font: font,
                                         lineSpacing: 1.4,
                                         textColor: textColor,
                                         alignment: alignment,
                                         lineBreakMode: .byWordWrapping)
    }
}
