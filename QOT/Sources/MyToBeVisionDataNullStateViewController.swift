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

final class MyToBeVisionDataNullStateViewController: UIViewController, ScreenZLevel3 {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var headingDescriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleDescriptionLabel: UILabel!

    private var tbvRateButton: UIButton?
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
            guard let finalTracks = tracks?.filter({ $0.toBeVisionId == self?.visionId }) else { return }
            self?.tbvRateButton?.isEnabled = finalTracks.count > 0
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
        ThemeText.tbvStatement.apply(ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateHeaderTitle).uppercased(), to: headingLabel)
        ThemeText.tbvBody.apply(ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateHeaderDesc), to: headingDescriptionLabel)
        ThemeText.tbvSectionHeader.apply(ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateTitleTitle).uppercased(), to: titleLabel)
        ThemeText.tbvBody.apply(ScreenTitleService.main.localizedString(for: .TbvDataEmptyStateTitleDesc), to: titleDescriptionLabel)
    }

    func formatted(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title,
                                  letterSpacing: 0.4,
                                  font: .sfProDisplayLight(ofSize: 24),
                                  lineSpacing: 7,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }
}

// MARK: - TBV TRACKER DID FINISH SYNC
extension MyToBeVisionDataNullStateViewController {
    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext else { return }
        if syncResult.dataType == .MY_TO_BE_VISION_TRACKER, syncResult.syncRequestType == .DOWN_SYNC {
            tbvRateButton?.isEnabled = true
        }
    }
}

// MARK: - Bottom Navigation Items
extension MyToBeVisionDataNullStateViewController {
    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [roundedBarButtonItem(title: R.string.localized.rateViewControllerRateMyTBVButton(),
                                     buttonWidth: .RateTBV,
                                     action: #selector(doneAction),
                                     backgroundColor: .carbon,
                                     borderColor: .accent)]
    }
}
