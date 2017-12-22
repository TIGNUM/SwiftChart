//
//  GuideDateStepperView.swift
//  QOT
//
//  Created by karmic on 22.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

var guideDate = Date()

private let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

final class GuideDateStepperView: UIView {

    @IBOutlet private weak var hourStepper: UIStepper!
    @IBOutlet private weak var dayStepper: UIStepper!
    @IBOutlet private weak var dateLabel: UILabel!
    private var viewModel: GuideViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        let calendar = Calendar.sharedUTC
        var components = DateComponents(calendar: calendar)
        hourStepper.value = Double(components.hour ?? 12)
        dayStepper.value = Double(components.day ?? 15)
    }

    func setupView(viewModel: GuideViewModel) {
        self.viewModel = viewModel

        var lastAddedDate = guideDate
        if viewModel.sectionCount > 0 {
            lastAddedDate = viewModel.header(section: 0)
        }
        dateLabel.text = shortDateFormatter.string(from: lastAddedDate)
    }
}

// MARK: - Private

private extension GuideDateStepperView {

    func updateGuideTime(hoursFromNow: Int) {
        let calendar = Calendar.sharedUTC
        var components = DateComponents()
        components.hour = hoursFromNow
        guideDate = calendar.date(byAdding: components, to: guideDate)!
        dateLabel.text = shortDateFormatter.string(from: guideDate)
        viewModel?.createTodaysGuideIfNeeded()
        viewModel?.reload()
    }

    func updateGuideDate(daysFromNow: Int) {
        let calendar = Calendar.sharedUTC
        var components = DateComponents()
        components.day = daysFromNow
        guideDate = calendar.date(byAdding: components, to: guideDate)!
        dateLabel.text = shortDateFormatter.string(from: guideDate)
        viewModel?.createTodaysGuideIfNeeded()
        viewModel?.reload()
    }
}

// MARK: - Actions

extension GuideDateStepperView {

    @IBAction func hourDidChangeValue(sender: UIStepper) {
        updateGuideTime(hoursFromNow: sender.stepValue.hashValue)
    }

    @IBAction func dayDidChangeValue(sender: UIStepper) {
        updateGuideDate(daysFromNow: sender.stepValue.toInt)
    }
}
