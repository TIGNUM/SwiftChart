//
//  TBVRateHistoryNullStateViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyToBeVisionDataNullStateViewControllerProtocol: class {
    func didRateTBV()
}

final class TBVRateHistoryNullStateViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    weak var delegate: MyToBeVisionDataNullStateViewControllerProtocol?
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var headingDescriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleDescriptionLabel: UILabel!
    private var rateIsEnabled = false
    var visionId: Int?

    private lazy var tbvRateButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(doneAction))
        ThemableButton.myTbvDataRate.apply(button, title: "===We need to Add AppTextKey here==="/*R.string.localized.rateViewControllerRateMyTBVButton()*/)
        return button.barButton
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        getVisionTracks()
        refreshBottomNavigationItems()
        setupEmptySate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Private
private extension TBVRateHistoryNullStateViewController {
    func getVisionTracks() {
        UserService.main.getToBeVisionTracksForRating { [weak self] (tracks) in
            guard let strongSelf = self else { return }
            let finalTracks = tracks.filter { $0.toBeVisionId == strongSelf.visionId }
            strongSelf.rateIsEnabled = !finalTracks.isEmpty
        }
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization,
                                               object: nil)
    }

    func setupEmptySate() {
        ThemeText.tbvStatement.apply("===We need to Add AppTextKey here==="/*ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateHeaderTitle).uppercased()*/,
            to: headingLabel)
        ThemeText.tbvBody.apply("===We need to Add AppTextKey here==="/*ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateHeaderDesc)*/,
            to: headingDescriptionLabel)
        ThemeText.tbvSectionHeader.apply("===We need to Add AppTextKey here==="/*ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateTitleTitle).uppercased()*/,
            to: titleLabel)
        ThemeText.tbvBody.apply("===We need to Add AppTextKey here==="/*ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateTitleDesc)*/,
            to: titleDescriptionLabel)
    }
}

// MARK: - Actions
extension TBVRateHistoryNullStateViewController {
    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext else { return }
        if syncResult.dataType == .MY_TO_BE_VISION_TRACKER, syncResult.syncRequestType == .DOWN_SYNC {
            getVisionTracks()
        }
    }

    @objc func doneAction() {
        trackUserEvent(.OPEN, action: .TAP)
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didRateTBV()
        }
    }
}

// MARK: - Bottom Navigation Items
extension TBVRateHistoryNullStateViewController {
    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rateIsEnabled ? [tbvRateButton] : []
    }
}
