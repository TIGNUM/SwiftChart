//
//  TodayViewController.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 05/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import NotificationCenter

enum Scene: String {
    case toBeVision = "qot://to-be-vision"
    case upComingEvents = "qot://prepare-event"
    case weeklyChoices = "qot://weekly-choices"
    case signIn = "qot://"
}

class WidgetViewController: UIViewController, NCWidgetProviding {

    // MARK: - Properties

    @IBOutlet private weak var myToBeVisionView: MyToBeVisionView!
    @IBOutlet private weak var upcomingEventsView: UpcomingEventsView!
    @IBOutlet private weak var weeklyChoicesView: WeeklyChoicesView!

    private var totalHeight: CGFloat {
        return myToBeVisionView.bounds.height + upcomingEventsView.bounds.height
    }

    private var isNetworkAvailable: Bool {
        return Connectivity.isNetworkAvailable()
    }

    private var isSignedIn: Bool {
        return WidgetUserDefaults.isUserSignedIn.value() as? Bool ?? false
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		syncDisplayMode()
        myToBeVisionView.delegate = self
        upcomingEventsView.delegate = self
        weeklyChoicesView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }

    // MARK: - Actions
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize.height = totalHeight
        } else {
            preferredContentSize = maxSize
        }
    }
}

// MARK: - Private

private extension WidgetViewController {

	func syncDisplayMode() {
        let shouldExpand = (isNetworkAvailable == true && isSignedIn == true)
        extensionContext?.widgetLargestAvailableDisplayMode = shouldExpand == true ? .expanded : .compact
    }

    func open(_ scene: Scene) {
        if let sceneURL = URL(string: scene.rawValue) {
            extensionContext?.open(sceneURL, completionHandler: nil)
        }
    }

    func setData() {
        if let toBeVision = WidgetUserDefaults.toBeVision() {
            myToBeVisionView.configure(toBeVision: toBeVision,
                                       isNetworkAvailable: isNetworkAvailable,
                                       isSignedIn: isSignedIn)
        }
        if let upcomingEvent = WidgetUserDefaults.upcomingEvent() {
            upcomingEventsView.configure(event: upcomingEvent)
        }
		if let weeklyChoices = WidgetUserDefaults.latestWeeklyChoices() {
			weeklyChoicesView.configure(weeklyChoices: weeklyChoices)
		}
    }
}

// MARK: - MyToBeVisionView Delegate

extension WidgetViewController: MyToBeVisionViewDelegate {

    func didTapCreateToBeVision(in view: UIView) {
        open(.toBeVision)
    }

    func didTapSignIn(in view: UIView) {
        open(.signIn)
    }
}

// MARK: - UpcomingEventsView Delegate

extension WidgetViewController: UpcomingEventsViewDelegate {

    func didTapCreateNewEvent() {
        open(.upComingEvents)
    }
}

// MARK: - WeeklyChoicesView Delegate

extension WidgetViewController: WeeklyChoicesViewDelegate {

    func didTapSetYourWeeklyChoices(in view: UIView) {
        open(.weeklyChoices)
    }
}
