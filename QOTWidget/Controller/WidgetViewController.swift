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
    case prepareEvent = "qot://prepare-event"
    case comingEvent = "qot://coming-event"
    case signIn = "qot://"
}

final class WidgetViewController: UIViewController, NCWidgetProviding {

    // MARK: - Properties

    @IBOutlet private weak var myToBeVisionView: MyToBeVisionView!

    private var totalHeight: CGFloat {
        return myToBeVisionView.bounds.height
    }

    private var isNetworkAvailable: Bool {
        return Connectivity.isNetworkAvailable()
    }

    private var isSignedIn: Bool {
        return ExtensionUserDefaults.isUserSignedIn.value(for: .widget) as? Bool ?? false
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		syncDisplayMode()
        myToBeVisionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }

    // MARK: - Actions
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
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
        let vision: ExtensionModel.ToBeVision? = ExtensionUserDefaults.object(for: .widget, key: .toBeVision)
        myToBeVisionView.configure(toBeVision: vision,
                                   isNetworkAvailable: isNetworkAvailable,
                                   isSignedIn: isSignedIn)
    }
}

// MARK: - MyToBeVisionView Delegate

extension WidgetViewController: MyToBeVisionViewDelegate {

    func didTapCreateToBeVision() {
        open(.toBeVision)
    }
    
    func didTapShowToBeVision() {
        open(.toBeVision)
    }

    func didTapSignIn() {
        open(.signIn)
    }
}
