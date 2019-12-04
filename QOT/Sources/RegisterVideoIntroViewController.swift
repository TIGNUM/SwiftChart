//
//  RegisterVideoIntroViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 29/11/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum RegisterVideoIntroCellTypes: Int, CaseIterable {
    case VideoCell = 0
    case NoteCell
}

final class RegisterVideoIntroViewController: BaseViewController, ScreenZLevelLogin {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var interactor: RegisterVideoIntroInteractorInterface?
    var router: RegisterVideoIntroRouterInterface?

    // MARK: - Init
    init(configure: Configurator<RegisterVideoIntroViewController>) {
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
        getVideoCell()?.stopPlaying()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getVideoCell()?.startPlayingFromBeggining()
    }

    // MARK: - Overridden
    override func canRotate() -> Bool {
        return true
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        let continueButton = RoundedButton.init(title: AppTextService.get(AppTextKey.onboarding_log_in_alert_device_small_screen_button_got_it),
                                        target: self,
                                        action: #selector(didTapContinue))
        ThemeButton.carbonButton.apply(continueButton)
        let heightConstraint = NSLayoutConstraint.init(item: continueButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        continueButton.addConstraints([heightConstraint])

        return [UIBarButtonItem(customView: continueButton)]
    }

    // MARK: - Actions
    @objc func didTapContinue() {
        router?.openRegistration()
    }

}

// MARK: - Private
extension RegisterVideoIntroViewController {
    @objc func didChangeOrientation() {
        guard let videoCell = getVideoCell() else { return }
        DispatchQueue.main.async {
            if UIDevice.current.orientation.isLandscape {
                videoCell.playerController.removeFromParentViewController()
                self.view.fill(subview: videoCell.playerController.view)
                self.addChildViewController(videoCell.playerController)
                videoCell.playerController.showsPlaybackControls = true
                self.updateBottomNavigation([], [])
            } else {
                UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
                videoCell.playerController.removeFromParentViewController()
                videoCell.mediaContentView.fill(subview: videoCell.playerController.view)
                videoCell.playerController.showsPlaybackControls = false
                self.refreshBottomNavigationItems()
            }
        }
    }

    private func getVideoCell() -> RegisterVideoIntroMediaTableViewCell? {
        return (tableView.cellForRow(at: IndexPath(row: RegisterVideoIntroCellTypes.VideoCell.rawValue, section: 0)) as? RegisterVideoIntroMediaTableViewCell)
    }
}

// MARK: - RegisterVideoIntroViewControllerInterface
extension RegisterVideoIntroViewController: RegisterVideoIntroViewControllerInterface {
    func setupView() {
        ThemeView.level2.apply(view)
        tableView.registerDequeueable(RegisterVideoIntroMediaTableViewCell.self)
        tableView.registerDequeueable(RegisterVideoIntroNoteTableViewCell.self)
    }
}

// MARK: - UITableView delegates and dataSource
extension RegisterVideoIntroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegisterVideoIntroCellTypes.allCases.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let reusableCell: RegisterVideoIntroMediaTableViewCell = tableView.dequeueCell(for: indexPath)
            reusableCell.configure(title: nil, subtitle: nil, videoURL: "https://d2gjspw5enfim.cloudfront.net/qot_web/qot_video.mp4")
            cell = reusableCell
        default:
            let reusableCell: RegisterVideoIntroNoteTableViewCell = tableView.dequeueCell(for: indexPath)
            cell = reusableCell
        }
        return cell
    }
}
