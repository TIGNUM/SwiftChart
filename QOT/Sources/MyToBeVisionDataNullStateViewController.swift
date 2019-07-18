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

final class MyToBeVisionDataNullStateViewController: UIViewController {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var HeadingDescriptionLabel: UILabel!
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
        emptyStateHeaderTitle {[weak self] (title) in
            self?.headingLabel.attributedText = self?.formatted(title: title.uppercased())
        }

        emptyStateHeaderDesc {[weak self] (title) in
            self?.HeadingDescriptionLabel.attributedText = self?.formatted(title: title)
        }

        emptyStateTitleTitle {[weak self] (title) in
            self?.titleLabel.attributedText = self?.formatted(title: title.uppercased())
        }

        emptyStateTitleDesc {[weak self] (title) in
            self?.titleDescriptionLabel.attributedText = self?.formatted(title: title)
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return generateBottomNavigationBarRighButtonItems()
    }

    @objc func doneAction() {
        trackUserEvent(.OPEN, action: .TAP)
        dismiss(animated: true) {[weak self] in
            self?.delegate?.didRateTBV()
        }
    }
}

private extension MyToBeVisionDataNullStateViewController {

    private func getVisionTracks() {
        userService.getToBeVisionTracksForRating {[weak self] (tracks, isInitialized, error) in
            guard let finalTracks = tracks?.filter({ $0.toBeVisionId == self?.visionId }) else { return }
            self?.tbvRateButton?.isEnabled = finalTracks.count > 0
        }
    }

    func addObserver() {
        NotificationCenter.default.addObserver(forName: .didFinishSynchronization, object: nil, queue: nil) {[weak self] (notification) in
            guard let syncResult = notification.object as? SyncResultContext else {
                return
            }
            if syncResult.dataType == .MY_TO_BE_VISION_TRACKER, syncResult.syncRequestType == .DOWN_SYNC {
                self?.tbvRateButton?.isEnabled = true
            }
        }
    }

    func generateBottomNavigationBarRighButtonItems() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: R.string.localized.rateViewControllerRateMyTBVButton(), buttonWidth: 121, action: #selector(doneAction), backgroundColor: .carbon, borderColor: .accent)]
    }
}

private extension MyToBeVisionDataNullStateViewController {

    func formatted(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title,
                                  letterSpacing: 0.4,
                                  font: .sfProDisplayLight(ofSize: 24),
                                  lineSpacing: 7,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }

    func emptyStateHeaderTitle(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.TBVData.emptyStateHeaderTitle.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func emptyStateHeaderDesc(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.TBVData.emptyStateHeaderDesc.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func emptyStateTitleTitle(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.TBVData.emptyStateTitleTitle.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func emptyStateTitleDesc(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.TBVData.emptyStateTitleDesc.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }
}
