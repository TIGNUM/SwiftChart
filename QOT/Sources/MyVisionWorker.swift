//
//  MyVisionWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionWorker {
    var nullStateSubtitle: String?
    var nullStateTitle: String?
    private var notRatedText: String? = ""
    private var syncingText: String? = ""
    private var toBeVision: QDMToBeVision?
    private var isMyVisionInitialized: Bool = false
    private var tracks: [QDMToBeVisionTrack]?
    private var report: QDMToBeVisionRatingReport?
    private let contentService: qot_dal.ContentService
    private let userService: qot_dal.UserService
    private let widgetDataManager: ExtensionsDataManager
    var toBeVisionDidChange: ((QDMToBeVision?) -> Void)?
    static var toBeSharedVisionHTML: String?

    init(userService: qot_dal.UserService, contentService: qot_dal.ContentService, widgetDataManager: ExtensionsDataManager) {
        self.userService = userService
        self.contentService = contentService
        self.widgetDataManager = widgetDataManager
        getNullStateSubtitle()
        getNullStateTitle()
        // Make sure that image directory is created.
        do {
            try FileManager.default.createDirectory(at: URL.imageDirectory, withIntermediateDirectories: true)
        } catch {
            qot_dal.log("failed to create image directory", level: .debug)
        }
    }

    var myVision: QDMToBeVision? {
        return toBeVision
    }

    var myVisionReport: QDMToBeVisionRatingReport? {
        return report
    }

    lazy var updateAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_tbv_alert_title_update)
    }()

    lazy var updateAlertMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_tbv_alert_body_update)
    }()

    lazy var updateAlertEditTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_tbv_alert_button_edit)
    }()

    lazy var updateAlertCreateTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_tbv_alert_button_create)
    }()

    lazy var emptyTBVTextPlaceholder: String = {
        return AppTextService.get(AppTextKey.my_qot_my_tbv_view_subtitle_vision)
    }()

    lazy var emptyTBVTitlePlaceholder: String = {
        return AppTextService.get(AppTextKey.my_qot_my_tbv_edit_title_placeholder)
    }()

    private func getNullStateSubtitle() {
        nullStateSubtitle = AppTextService.get(AppTextKey.my_qot_my_tbv_view_subtitle_null_state)
    }

    private func getNullStateTitle() {
        nullStateTitle = AppTextService.get(AppTextKey.my_qot_my_tbv_view_title_null_state)
    }

    func getData(_ completion: @escaping(_ initialized: Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        myToBeVision(dispatchGroup)
        getRatingReport(dispatchGroup)
        getSyncingText(dispatchGroup)
        getNotRatedText(dispatchGroup)
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.getVisionTracks {
                completion(self?.isMyVisionInitialized ?? false)
            }
        }
    }

    private func myToBeVision(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        userService.getMyToBeVision({ [weak self] (vision, initialized, error) in
            self?.toBeVision = vision
            self?.isMyVisionInitialized = initialized
            dispatchGroup.leave()
        })
    }

    private func getRatingReport(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        userService.getToBeVisionTrackingReport(last: 1) {[weak self] (report) in
            self?.report = report
            dispatchGroup.leave()
        }
    }

    private func getVisionTracks(_ completion: @escaping() -> Void) {
        userService.getToBeVisionTracksForRating {[weak self] (tracks, isInitialized, error) in
            guard let finalTracks = tracks?.filter({ $0.toBeVisionId == self?.toBeVision?.remoteID }) else { return }
            self?.tracks = finalTracks
            completion()
        }
    }

    func updateMyToBeVision(_ new: QDMToBeVision, completion: @escaping () -> Void) {
        userService.updateMyToBeVision(new) { error in
            self.updateWidget()
            completion()
        }
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }

    func shouldShowWarningIcon() -> Bool {
        guard let date =  toBeVision?.date else {
            return true
        }
        let daysOld = DateComponentsFormatter.numberOfDays(date)
        let fourWeeks = 28 // 4 weeks = 28 days
        return daysOld > fourWeeks
    }

    func lastUpdatedVision() -> String? {
        guard let date =  toBeVision?.date else { return nil }
        let days = DateComponentsFormatter.numberOfDays(date)
        return dateString(for: days)
    }

    func visionToShare(_ completion: @escaping (QDMToBeVisionShare?) -> Void) {
        userService.getMyToBeVisionShareData { (visionShare, initialized, error) in
            MyVisionWorker.toBeSharedVisionHTML = visionShare?.body
            completion(visionShare)
        }
    }

    func updateWidget() {
        widgetDataManager.update(.toBeVision)
    }

    func getSyncingText(_ dispatchGroup: DispatchGroup) {
        syncingText = AppTextService.get(AppTextKey.my_qot_my_tbv_view_title_syncing)
    }

    func getNotRatedText(_ dispatchGroup: DispatchGroup) {
        notRatedText = AppTextService.get(AppTextKey.my_qot_my_tbv_view_title_not_rated)
    }

    func updateRateButton() -> (String?, Bool?, Bool) {
        guard let tracks = self.tracks, tracks.count > 0 else {
            return (syncingText, nil, false)
        }
        guard let report = self.report, report.days.count > 0 else {
            return (notRatedText, true, true)
        }
        guard let date = report.days.first else {
            return (syncingText, true, false)
        }
        let days = DateComponentsFormatter.numberOfDays(date)
        return (dateString(for: days), false, true)
    }

    private func dateString(for day: Int) -> String {
        if day == 0 {
            return "Today"
        } else if day == 1 {
            return "Yesterday"
        } else {
            return String(day) + " Days"
        }
    }
}
