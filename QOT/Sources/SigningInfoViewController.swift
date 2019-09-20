//
//  SigningInfoViewController.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    var interactor: SigningInfoInteractorInterface?
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    var delegate: SigningInfoDelegate?

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationHandler.postNotification(withName: .showSigningInfoView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        refreshBottomNavigationItems()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()

        UIView.animate(withDuration: Animation.duration_03) {
            self.view.alpha = 0
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.alpha = 1
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

// MARK: - Private
private extension SigningInfoViewController {
    func setupButtons() {
        ThemeBorder.accent.apply(loginButton)
        ThemeBorder.accent.apply(startButton)
    }
}

// MARK: - Actions
private extension SigningInfoViewController {

    @IBAction func didTapLogin() {
        interactor?.didTapLoginButton()
    }

    @IBAction func didTapStart() {
        interactor?.didTapStartButton()
    }
}

// MARK: - SigningInfoViewControllerInterface
extension SigningInfoViewController: SigningInfoViewControllerInterface {
    func setup() {
        setupButtons()
    }

    func presentUnoptimizedAlertView(title: String, message: String, dismissButtonTitle: String) {
        let doneButton = QOTAlertAction(title: dismissButtonTitle)
        QOTAlert.show(title: title,
                      message: message,
                      bottomItems: [doneButton])
    }
}
