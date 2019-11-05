//
//  RegistrationViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var pageIndicatorView: UIView!
    @IBOutlet private weak var pageContainerView: UIView!

    private let pageIndicator = MyToBeVisionPageComponentView()
    private var pageController: UIPageViewController?
    private let alertButtonWidth: CGFloat = 140
    private var bottomItems = UINavigationItem()

    var interactor: RegistrationInteractorInterface?

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainerView.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBottomNavigationItems()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if let buttons = bottomItems.leftBarButtonItems {
            return buttons
        }
        return interactor?.currentController?.bottomNavigationLeftBarItems()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if let buttons = bottomItems.rightBarButtonItems {
            return buttons
        }
        return interactor?.currentController?.bottomNavigationRightBarItems()
    }
}

// MARK: - Private

private extension RegistrationViewController {
    func bottomButton(with title: String, selector: Selector) -> UIBarButtonItem {
        return roundedBarButtonItem(title: title,
                                    image: nil,
                                    buttonWidth: alertButtonWidth,
                                    action: selector,
                                    backgroundColor: .clear,
                                    borderColor: .accent40)
    }
}

// MARK: - Actions

private extension RegistrationViewController {
    @objc func loginWithTBV() {
        if hasInternet() {
            interactor?.navigateToLogin(shouldSaveToBeVision: true)
        }
    }

    @objc func loginWithoutTBV() {
        if hasInternet() {
            interactor?.navigateToLogin(shouldSaveToBeVision: false)
        }
    }
}

// MARK: - RegistrationViewControllerInterface

extension RegistrationViewController: RegistrationViewControllerInterface {

    func setupView() {
        view.backgroundColor = .carbon

        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageColor = .sand
        pageIndicator.pageCount = interactor?.totalPageCount ?? 4
        pageIndicator.currentPageIndex = 0

        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController = pageController
        pageContainerView.addSubview(pageController.view)
        pageContainerView.fill(subview: pageController.view)
        self.addChildViewController(pageController)

        if let controller = interactor?.currentController {
            pageController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        }
        refreshBottomNavigationItems()
    }

    func show(alert: RegistrationExistingUserAlertViewModel) {
        let withoutTBV = QOTAlertAction(title: alert.discardTBVTitle, target: self, action: #selector(loginWithoutTBV))
        let saveTBV = QOTAlertAction(title: alert.saveTBVTitle, target: self, action: #selector(loginWithTBV))
        QOTAlert.show(title: alert.alertTitle, message: alert.alertMessage, bottomItems: [withoutTBV, saveTBV])
    }

    func update(controller: UIViewController, direction: UIPageViewController.NavigationDirection) {
        if let page = interactor?.currentPage, page < pageIndicator.pageCount {
            pageIndicator.isHidden = false
            pageIndicator.currentPageIndex = page
        } else {
            pageIndicator.isHidden = true
        }
        pageController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }

    func showExistingAccountAlert(title: String, message: String) {
        let infoAlertView = InfoAlertView()
        infoAlertView.set(icon: R.image.ic_warning(), title: title, text: message)
        infoAlertView.bottomInset = BottomNavigationContainer.height
        infoAlertView.present(on: self.view)
    }

    func showAlert(message: String) {
        QOTAlert.show(title: nil, message: message)
    }
}
