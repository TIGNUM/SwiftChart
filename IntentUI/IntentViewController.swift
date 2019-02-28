//
//  IntentViewController.swift
//  IntentUI
//
//  Created by Javier Sanz Rozalén on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import IntentsUI

final class IntentViewController: UIViewController, INUIHostedViewControlling {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    // MARK: - INUIHostedViewControlling
    
    func configureView(for parameters: Set<INParameter>,
                       of interaction: INInteraction,
                       interactiveBehavior: INUIInteractiveBehavior,
                       context: INUIHostedViewContext,
                       completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        if let response = interaction.intentResponse as? ReadVisionIntentResponse {
            let viewController = ReadVisionViewController(for: response)
            let shouldDisplay = response.code != .noVision
            attachChild(viewController)
            completion(shouldDisplay, parameters, viewController.viewSize)
        }
        if let response = interaction.intentResponse as? WhatsHotIntentResponse {
            let viewController = WhatsHotViewController(for: response)
            let size = response.code == .noNewArticles ? .zero : viewController.viewSize
            let shouldDisplay = response.code != .noNewArticles
            attachChild(viewController)
            completion(shouldDisplay, parameters, size)
        }
        if let response = interaction.intentResponse as? UpcomingEventIntentResponse {
            let viewController = UpcomingEventViewController(for: response)
            let size = response.code == .noUpcomingEvents ? .zero : viewController.viewSize
            let shouldDisplay = response.code != .noUpcomingEvents
            attachChild(viewController)
            completion(shouldDisplay, parameters, size)
        }
        if let response = interaction.intentResponse as? DailyPrepIntentResponse {
            let viewController = DailyPrepViewController(for: response)
            let shouldDisplay = response.code != .notCompleted
            attachChild(viewController)
            completion(shouldDisplay, parameters, viewController.viewSize)
        }
        completion(false, parameters, .zero)
    }
}

// MARK: - Private

private extension IntentViewController {
    
    func attachChild(_ viewController: UIViewController) {
        addChild(viewController)
        if let subview = viewController.view {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            subview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        viewController.didMove(toParent: self)
    }
}

// MARK: - UIViewController

fileprivate extension UIViewController {

    var viewSize: CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
}
