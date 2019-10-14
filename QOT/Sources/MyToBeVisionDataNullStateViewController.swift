//
//  MyToBeVisionDataNullStateViewController.swift
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

final class MyToBeVisionDataNullStateViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var headingDescriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleDescriptionLabel: UILabel!
    private var rateIsEnabled = false

    private lazy var tbvRateButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(doneAction))
        ThemableButton.myTbvDataRate.apply(button, title: AppTextService.get(AppTextKey.my_qot_my_tbv_rate_view_rate_button_title))
        return button.barButton
    }()
    private let userService = qot_dal.UserService.main
    private let contentService = qot_dal.ContentService.main
    weak var delegate: MyToBeVisionDataNullStateViewControllerProtocol?
    var visionId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        getVisionTracks()
        setupEmptySate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc func doneAction() {
        trackUserEvent(.OPEN, action: .TAP)
        dismiss(animated: true) {[weak self] in
            self?.delegate?.didRateTBV()
        }
    }
}

private extension MyToBeVisionDataNullStateViewController {
    func getVisionTracks() {
        userService.getToBeVisionTracksForRating {[weak self] (tracks, isInitialized, error) in
            if let finalTracks = tracks?.filter({ $0.toBeVisionId == self?.visionId }) {
                self?.rateIsEnabled = finalTracks.count > 0
            } else {
                self?.rateIsEnabled = false
            }
            self?.refreshBottomNavigationItems()
        }
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization,
                                               object: nil)
    }
}

private extension MyToBeVisionDataNullStateViewController {
    func setupEmptySate() {
        ThemeText.tbvStatement.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_my_tbv_data_empty_header_title), to: headingLabel)
        ThemeText.tbvBody.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_my_tbv_data_empty_header_description_title), to: headingDescriptionLabel)
        ThemeText.tbvSectionHeader.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_my_tbv_data_empty_title), to: titleLabel)
        ThemeText.tbvBody.apply(AppTextService.get(AppTextKey.my_qot_my_tbv_my_tbv_data_empty_title_description_title), to: titleDescriptionLabel)
    }
}

// MARK: - TBV TRACKER DID FINISH SYNC
extension MyToBeVisionDataNullStateViewController {
    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext else { return }
        if syncResult.dataType == .MY_TO_BE_VISION_TRACKER, syncResult.syncRequestType == .DOWN_SYNC {
            getVisionTracks()
        }
    }
}

// MARK: - Bottom Navigation Items
extension MyToBeVisionDataNullStateViewController {
    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rateIsEnabled ? [tbvRateButton] : []
    }
}
