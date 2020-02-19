//
//  SigningInfoViewController.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import qot_dal

final class SigningInfoViewController: BaseViewController, ScreenZLevel2 {

    // MARK: - Properties
    let mediaName = "LoginVideo"
    let mediaExtension = "mp4"
    // Video player
    var interactor: SigningInfoInteractorInterface?
    var player: AVQueuePlayer? = AVQueuePlayer()
    var playerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?

    var loginButton: UIBarButtonItem = UIBarButtonItem.init()
    var registerButton: UIBarButtonItem = UIBarButtonItem.init()

    // Outlets
    @IBOutlet private weak var videoContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!

    @IBOutlet private weak var titleLabelWidthConstraint: NSLayoutConstraint!
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
        updateBottomNavigation([], [])
        navigationController?.navigationBar.isHidden = true
        player?.play()
        // QOT-2367: Dismiss Loading Indicator
        SVProgressHUD.dismiss()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBottomNavigation([], [])
        trackPage()
        setupText()
        setupStartButton()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }
}

// MARK: - Private
private extension SigningInfoViewController {
    func setupText() {
        let maxWidth = view.bounds.width * titleLabelWidthConstraint.multiplier
        ThemeText.onboardingInfoTitle.applyScale(interactor?.titleText, to: titleLabel, maxWidth: maxWidth)
        ThemeText.onboardingInfoBody.apply(interactor?.bodyText, to: bodyLabel)

        UIView.animate(withDuration: 3.0) {
            self.titleLabel.alpha = 1.0
            self.bodyLabel.alpha = 1.0
        }
    }

    func setupStartButton() {
        let attributedString = NSAttributedString(string: interactor?.startButtonText ?? "",
                                                  letterSpacing: 0.2,
                                                  font: .sfProtextSemibold(ofSize: 14),
                                                  textColor: .accent,
                                                  alignment: .center)
        startButton.setAttributedTitle(attributedString, for: .normal)
        startButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
    }
}

// MARK: - Actions
private extension SigningInfoViewController {
    @IBAction func didTapStart() {
        trackUserEvent(.GET_STARTED, action: .TAP)
        interactor?.didTapStartButton()
    }
}

// MARK: - SigningInfoViewControllerInterface
extension SigningInfoViewController: SigningInfoViewControllerInterface {
    func setup() {
        ThemeView.level1.apply(view)
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
