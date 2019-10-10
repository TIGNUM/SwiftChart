//
//  SigningInfoViewController.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import AVFoundation

final class SigningInfoViewController: BaseViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    let mediaName = "LoginVideo"
    let mediaExtension = "mp4"
    // Video player
    var interactor: SigningInfoInteractorInterface?
    var player: AVQueuePlayer? = AVQueuePlayer()
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?

    // Outlets
    @IBOutlet private weak var videoContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var loginButton: RoundedButton!
    @IBOutlet private weak var startButton: RoundedButton!
    weak var delegate: SigningInfoDelegate?

    // MARK: - Init
    init() {
        if let media = Bundle.main.url(forResource: mediaName, withExtension: mediaExtension), let player = player {
            let playerItem = AVPlayerItem(url: media)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        } else {
            playerLooper = nil
        }

        playerLayer = AVPlayerLayer(player: player)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let playerLayer = playerLayer {
            videoContainerView.layer.addSublayer(playerLayer)
        }

        interactor?.viewDidLoad()
        NotificationHandler.postNotification(withName: .showSigningInfoView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        refreshBottomNavigationItems()
        player?.play()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        setupText()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()

        UIView.animate(withDuration: Animation.duration_03) {
            self.view.alpha = 0
            self.titleLabel.alpha = 0.0
            self.bodyLabel.alpha = 0.0
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.alpha = 1
        player?.pause()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
}

// MARK: - Private
private extension SigningInfoViewController {
    func setupText() {
        ThemeText.onboardingInfoTitle.applyScale(interactor?.titleText, to: titleLabel, maxWidth: titleLabel.bounds.width)
        ThemeText.onboardingInfoBody.apply(interactor?.bodyText, to: bodyLabel)

        UIView.animate(withDuration: 3.0) {
            self.titleLabel.alpha = 1.0
            self.bodyLabel.alpha = 1.0
        }
    }

    func setupButtons() {
        ThemableButton.signinInfo.apply(loginButton, title: R.string.localized.onboardingIntroButtonLogin())
        ThemableButton.signinInfo.apply(startButton, title: R.string.localized.onboardingIntroButtonRegister())
    }
}

// MARK: - Actions
private extension SigningInfoViewController {

    @IBAction func didTapLogin() {
        trackUserEvent(.LOG_IN, action: .TAP)
        interactor?.didTapLoginButton()
    }

    @IBAction func didTapStart() {
        trackUserEvent(.NEW_USER, action: .TAP)
        interactor?.didTapStartButton()
    }
}

// MARK: - SigningInfoViewControllerInterface
extension SigningInfoViewController: SigningInfoViewControllerInterface {
    func setup() {
        ThemeView.level1.apply(view)
        setupButtons()
        titleLabel.alpha = 0.0
        bodyLabel.alpha = 0.0
    }

    func didFinishLogin() {
        player?.removeAllItems()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        playerLooper?.disableLooping()
        playerLooper = nil
    }

    func presentUnoptimizedAlertView(title: String, message: String, dismissButtonTitle: String) {
        let doneButton = QOTAlertAction(title: dismissButtonTitle)
        QOTAlert.show(title: title,
                      message: message,
                      bottomItems: [doneButton])
    }
}
