//
//  UpcomingEventViewController.swift
//  IntentUI
//
//  Created by Javier Sanz Rozalén on 14.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Intents

@available(iOSApplicationExtension 12.0, *)
final class UpcomingEventViewController: UIViewController {

    // MARK: - Properties

    private let intentResponse: UpcomingEventIntentResponse
    @IBOutlet private weak var upcomingEventView: UpcomingEventView!

    // MARK: - Init

    init(for response: UpcomingEventIntentResponse) {
        self.intentResponse = response
        super.init(nibName: "UpcomingEventView", bundle: Bundle(for: UpcomingEventViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingEventView.configure(eventsDate: intentResponse.firstEventStartDate,
                                    firstEventName: intentResponse.firstEventTitle,
                                    firstEventDate: intentResponse.firstEventDuration)
    }
}

final class UpcomingEventView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var firstEventNameLabel: UILabel!
    @IBOutlet private weak var firstEventTimeLabel: UILabel!

    // MARK: - Configuration

    func configure(eventsDate: String?,
                   firstEventName: String?,
                   firstEventDate: String?) {
        dateLabel.text = eventsDate
        firstEventNameLabel.text = firstEventName
        firstEventTimeLabel.text = firstEventDate
    }
}
