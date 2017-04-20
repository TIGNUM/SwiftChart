//
//  RootViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// Unimplemented but will likely be a custom tab bar container view that 
/// switches between *learn*, *me*, and *prepare* sections.
final class RootViewController: UIViewController {

    // MARK: - Properties

//    fileprivate lazy var containerView = UIView()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
    }

    // MARK: - Add Container

    private func containerView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ])

        return containerView
    }

    // MARK: - Add Child View Controlller

    func addChildViewControllerToContainer(childViewController: UIViewController) {
        let containerView = self.containerView()
        addChildViewController(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childViewController.view)

        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

        childViewController.didMove(toParentViewController: self)
    }

    func addTopTabBarldViewControllerToContainer(childViewController: UIViewController) {
        let containerView = self.containerView()
        addChildViewController(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childViewController.view)

        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

        childViewController.didMove(toParentViewController: self)
    }
}
