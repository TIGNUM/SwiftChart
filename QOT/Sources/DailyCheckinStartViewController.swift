//
//  DailyCheckinStartViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 12.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

protocol DailyCheckinStartViewControllerDelegate: class {
    func showQuestions()
}


final class DailyCheckinStartViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lineView: UIView!

    private var isLoading = true
    private var buttonTitle: String = ""
    var interactor: DailyCheckinStartInteractorInterface?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.darkNot.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dotsLoadingView.configure(dotsColor: .carbonDark)
        dotsLoadingView.startAnimation()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setStatusBar(colorMode: ColorMode.darkNot)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return isLoading == true ? nil : generateBottomNavigationBarRighButtonItems()
    }
}

// MARK: - Private

private extension DailyCheckinStartViewController {

    func generateBottomNavigationBarRighButtonItems() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: buttonTitle,
                                     buttonWidth: 121,
                                     action: #selector(letsStartAction),
                                     backgroundColor: .carbonDark,
                                     borderColor: .clear)]
    }

    @objc func letsStartAction() {
        trackUserEvent(.CONFIRM, action: .TAP)
        interactor?.showQuestions()
    }
}

// MARK: - Actions

private extension DailyCheckinStartViewController {

}

// MARK: - DailyCheckinStartViewControllerInterface

extension DailyCheckinStartViewController: DailyCheckinStartViewControllerInterface {

    func setupView(title: String?, subtitle: String, buttonTitle: String?) {
        isLoading = false
        titleLabel.text = title
        subtitleLabel.text = subtitle
        self.buttonTitle = buttonTitle ?? ""
        bottomConstraint.constant = 100
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: {[weak self] (value: Bool) in
            self?.dotsLoadingView.stopAnimation()
            self?.lineView.isHidden = false
            self?.dotsLoadingView.isHidden = true
            self?.refreshBottomNavigationItems()
        })
    }
}

extension DailyCheckinStartViewController: DailyCheckinStartViewControllerDelegate {

    func showQuestions() {
        interactor?.showQuestions()
    }
}
