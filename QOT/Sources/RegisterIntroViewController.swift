//
//  RegisterIntroViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 05/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum RegisterIntroCellTypes: Int, CaseIterable {
    case VideoCell = 0
    case NoteCell
}

protocol RegisterIntroUserEventTrackDelegate: class {
    func didMuteVideo()
    func didUnMuteVideo()
}

final class RegisterIntroViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var interactor: RegisterIntroInteractorInterface!
    private lazy var router = RegisterIntroRouter(viewController: self)
    private lazy var videoCell: RegisterIntroMediaTableViewCell = {
        let cell = R.nib.registerIntroMediaTableViewCell.firstView(owner: self)
        cell?.configure(title: AppTextService.get(.onboarding_register_intro_video_section_header_title),
                       body: AppTextService.get(.onboarding_register_intro_video_section_body),
                       videoURL: "https://d2gjspw5enfim.cloudfront.net/qot_web/qot_video.mp4")
        return cell ?? RegisterIntroMediaTableViewCell()
    }()

    private var expanded = false

    // MARK: - Init
    init(configure: Configurator<RegisterIntroViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

     // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeOrientation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCell.stopPlaying()
        AppCoordinator.orientationManager.regular()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppCoordinator.orientationManager.videos()
        videoCell.startPlayingFromBeggining()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    // MARK: - Overridden
    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        let continueButton = RoundedButton.init(title: AppTextService.get(AppTextKey.onboarding_sign_up_email_verification_section_footer_button_next),
                                        target: self,
                                        action: #selector(didTapContinue))
        ThemeButton.carbonButton.apply(continueButton)
        let heightConstraint = NSLayoutConstraint.init(item: continueButton,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1,
                                                       constant: 40)
        continueButton.addConstraints([heightConstraint])

        return [UIBarButtonItem(customView: continueButton)]
    }

    // MARK: - Actions
    @objc func didTapContinue() {
        trackUserEvent(.CONTINUE, stringValue: "openRegistration", action: .TAP)
        router.openRegistration()
    }
}

// MARK: - Private
extension RegisterIntroViewController {
    @objc func didChangeOrientation() {
        DispatchQueue.main.async {
            if UIDevice.current.orientation.isLandscape {
                self.trackUserEvent(.ORIENTATION_CHANGE, valueType: .LANDSCAPE, action: .ROTATE)
                self.videoCell.playerController.removeFromParentViewController()
                self.view.fill(subview: self.videoCell.playerController.view)
                self.addChildViewController(self.videoCell.playerController)
                self.videoCell.playerController.showsPlaybackControls = true
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.updateBottomNavigation([], [])
            } else {
                self.trackUserEvent(.ORIENTATION_CHANGE, valueType: .PORTRAIT, action: .ROTATE)
                UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                self.videoCell.playerController.removeFromParentViewController()
                self.videoCell.mediaContentView.fill(subview: self.videoCell.playerController.view)
                self.videoCell.playerController.showsPlaybackControls = false
                self.videoCell.soundToggleButton.isSelected = !(self.videoCell.playerController.player?.isMuted ?? true)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.refreshBottomNavigationItems()
            }
        }
    }

    private func getNoteCell() -> RegisterIntroNoteTableViewCell {
        let cell = R.nib.registerIntroNoteTableViewCell.firstView(owner: self)
        let longBody = AppTextService.get(.onboarding_register_intro_note_section_body)
        let shortBody = String.init(longBody.split(separator: "\n").first ?? "")
        cell?.configure(title: AppTextService.get(.onboarding_register_intro_note_section_title),
                        body: expanded ? longBody : shortBody,
                        expanded: expanded)
        cell?.delegate = self
        return cell ?? RegisterIntroNoteTableViewCell()
    }
}

// MARK: - RegisterIntroViewControllerInterface
extension RegisterIntroViewController: RegisterIntroViewControllerInterface {
    func setupView() {
        ThemeView.level2.apply(view)
        tableView.registerDequeueable(RegisterIntroMediaTableViewCell.self)
        tableView.registerDequeueable(RegisterIntroNoteTableViewCell.self)
    }
}

// MARK: - UITableView delegates and dataSource
extension RegisterIntroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegisterIntroCellTypes.allCases.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.row == 0 ? videoCell : getNoteCell()
    }
}

extension RegisterIntroViewController: RegisterIntroNoteTableViewCellDelegate {
    func didTapReadMore() {
        trackUserEvent(.READ_MORE, action: .TAP)
        expanded = true
        tableView.reloadRows(at: [IndexPath(row: RegisterIntroCellTypes.NoteCell.rawValue,
                                           section: 0)],
                             with: .fade)
    }
}

// MARK: - RegisterIntroUserEventTrackDelegate
extension RegisterIntroViewController: RegisterIntroUserEventTrackDelegate {
    func didMuteVideo() {
        trackUserEvent(.MUTE_VIDEO, action: .TAP)
    }

    func didUnMuteVideo() {
        trackUserEvent(.UNMUTE_VIDEO, action: .TAP)
    }
}
