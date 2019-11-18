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
        ThemableButton.myTbvDataRate.apply(button, title: AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data_null_state_button_rate))
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
        ThemeText.tbvStatement.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data_null_state_section_header_header),
            to: headingLabel)
        ThemeText.tbvBody.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data_null_state_section_header_body),
            to: headingDescriptionLabel)
        ThemeText.tbvSectionHeader.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data_null_state_section_my_tbv_title),
            to: titleLabel)
        ThemeText.tbvBody.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_tbv_tracker_data_null_state_section_my_tbv_title_description),
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
