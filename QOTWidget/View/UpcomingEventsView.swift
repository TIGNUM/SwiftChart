//
//  UpcomingEventsView.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 05/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol UpcomingEventsViewDelegate: class {
    func didTapCreateNewEvent()
}

final class UpcomingEventsView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var eventTimeLabel: UILabel!
    @IBOutlet private weak var tasksCompletedLabel: UILabel!
    @IBOutlet private weak var createNewEventButton: UIButton!
    weak var delegate: UpcomingEventsViewDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Actions

    func configure(event: WidgetModel.UpcomingEvent) {
        if let eventName = event.eventName {
            eventNameLabel.text = eventName
            eventTimeLabel.text = dateDescription(for: event.eventDate ?? nil)
            if let tasks = event.numberOfTasks, let tasksCompleted = event.tasksCompleted, tasks > 0 {
                tasksCompletedLabel.text = "\(tasksCompleted)/\(tasks) Tasks Completed"
                tasksCompletedLabel.textColor = tasksCompleted == tasks ? .green : .red
            }
        }
    }

    @IBAction func didTapCreateToBeVision(_ sender: UIButton) {
        delegate?.didTapCreateNewEvent()
    }
}

// MARK: - Private

private extension UpcomingEventsView {

    func setupView() {
        eventTimeLabel.adjustsFontSizeToFitWidth = true
        createNewEventButton.layer.cornerRadius = 6
        eventNameLabel.textColor = .gray
    }

    func dateDescription(for date: Date?) -> String {
        guard let date = date else { return "" }
        let calendar = Calendar.current
        if date.isSameDay(Date()) {
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            return "\(hour):\(minute)"
        } else {
            let day = calendar.component(.day, from: date)
            let month = date.monthDescription
            return "\(day) \(month.prefix(3))"
        }
    }
}
