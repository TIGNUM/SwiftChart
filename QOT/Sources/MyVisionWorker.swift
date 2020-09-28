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

    private enum SharingKeys: String {
        case firstName = "*|FIRSTNAME|*"
        case tbv = "*|MTBV|*"
        case genderHerHis = "*|GENDER-HER-HIS|*"
        case genderSheHe = "*|GENDER-SHE-HE|*"
        case genderHerHim = "*|GENDER-HER-HIM|*"
        case genderHerselfHimself = "*|GENDER-HERSELF-HIMSELF|*"

        func pronoun(_ gender: Gender) -> String {
            switch self {
            case .genderHerHim: return gender == .female ? "her" : (gender == .male ? "him" : "them")
            case .genderSheHe: return gender == .female ? "she" : (gender == .male ? "he" : "they")
            case .genderHerHis: return gender == .female ? "her" : (gender == .male ? "his" : "their")
            case .genderHerselfHimself: return gender == .female ? "herself" : (gender == .male ? "himself" : "themself")
            default: return ""
            }
        }
    }

    lazy var nullStateSubtitle = AppTextService.get(.my_qot_my_tbv_null_state_body)
    lazy var nullStateTitle = AppTextService.get(.my_qot_my_tbv_null_state_title)
    lazy var nullStateCTA = AppTextService.get(.my_qot_my_tbv_null_state_button_write)
    lazy var nullStateTeamCTA = AppTextService.get(.myx_team_tbv_null_state_cta)
    lazy var updateAlertTitle = AppTextService.get(.my_qot_my_tbv_alert_update_title)
    lazy var updateAlertMessage = AppTextService.get(.my_qot_my_tbv_alert_update_body)
    lazy var updateAlertEditTitle = AppTextService.get(.my_qot_my_tbv_alert_update_edit)
    lazy var updateAlertCreateTitle = AppTextService.get(.my_qot_my_tbv_alert_update_create)
    lazy var emptyTBVTextPlaceholder = AppTextService.get(.my_qot_my_tbv_empty_subtitle_vision)
    lazy var emptyTBVTitlePlaceholder = AppTextService.get(.my_qot_my_tbv_section_header_title_headline)
    private lazy var widgetDataManager = ExtensionsDataManager()
    private var toBeVision: QDMToBeVision?
    var toBeVisionDidChange: ((QDMToBeVision?) -> Void)?
    static var toBeSharedVisionHTML: String?

    init() {
        // Make sure that image directory is created.
        do {
            try FileManager.default.createDirectory(at: URL.imageDirectory, withIntermediateDirectories: true)
        } catch {
            log("failed to create image directory", level: .debug)
        }
    }

    func getRatingReport(_ completion: @escaping (QDMToBeVisionRatingReport?) -> Void) {
        UserService.main.getToBeVisionTrackingReport(last: 3) { (report) in
            completion(report)
        }
    }

    func getToBeVision(_ completion: @escaping (QDMToBeVision?) -> Void) {
        UserService.main.getMyToBeVision { [weak self] (vision, _, error) in
            if let error = error {
                log("Error - getMyToBeVision: \(error.localizedDescription)", level: .error)
            }
            self?.toBeVision = vision
            completion(vision)
        }
    }

    func getVisionTracks(_ completion: @escaping ([QDMToBeVisionTrack]) -> Void) {
        UserService.main.getToBeVisionTracksForRating { (tracks) in
            completion(tracks)
        }
    }

    func updateMyToBeVision(_ new: QDMToBeVision, completion: @escaping (_ toBeVision: QDMToBeVision?) -> Void) {
        UserService.main.updateMyToBeVision(new) { [weak self] error in
            self?.getToBeVision { [weak self] (qdmVision) in
                self?.updateWidget()
                completion(qdmVision)
            }
        }
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }

    func shouldShowWarningIcon(_ completion: @escaping (Bool) -> Void) {
        getVisionTracks { (tracks) in
            let date = Date(timeIntervalSince1970: 0)

            if let track = tracks.sorted(by: { $0.createdAt ?? date > $1.createdAt ?? date }).first,
                let rating = track.ratings.sorted(by: { $0.isoDate > $1.isoDate }).first {

                let daysOld = DateComponentsFormatter.numberOfDays(rating.isoDate)
                let fourWeeks = 28 // 4 weeks = 28 days
                completion(daysOld > fourWeeks)
                return
            }
            completion(false)
        }
    }

    func lastUpdatedVision() -> String? {
        guard let date = toBeVision?.date?.beginingOfDate() else { return nil }
        let days = DateComponentsFormatter.numberOfDays(date)
        return dateString(for: days)
    }

    func visionToShare(_ completion: @escaping (QDMToBeVisionShare?) -> Void) {
        UserService.main.getMyToBeVisionShareData { (visionShare, _, _) in
            MyVisionWorker.toBeSharedVisionHTML = visionShare?.body
            completion(visionShare)
        }
    }

    func updateWidget() {
        widgetDataManager.update(.toBeVision)
    }

    func getRateButtonValues(_ completion: @escaping (TBVRatingView, QDMToBeVision?) -> Void) {
        let syncingText = AppTextService.get(.my_qot_my_tbv_loading_body_syncing)
        let notRatedText = AppTextService.get(.my_qot_my_tbv_section_track_null_state_title)
        let dispatchGroup = DispatchGroup()
        var ratingReport: QDMToBeVisionRatingReport?
        var tbvTracks = [QDMToBeVisionTrack]()
        var sentences = [String]()
        var tbv: QDMToBeVision?

        dispatchGroup.enter()
        getRatingReport { (report) in
            ratingReport = report
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getVisionTracks { (tracks) in
            tbvTracks = tracks
            sentences = tracks.compactMap { $0.sentence }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getToBeVision { (toBeVision) in
            tbv = toBeVision
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            // completion(myVision, rateText, doubleMsgViewIsHidden, rateEnabled)
            var ratingView = TBVRatingView()

            guard let visionText = tbv?.text, tbvTracks.isEmpty == false else {
                ratingView.isHidden = true
                ratingView.singleMsgViewIsHidden = true
                ratingView.doubleMsgViewIsHidden = true
                completion(ratingView, tbv)
                requestSynchronization(.MY_TO_BE_VISION_TRACKER, .DOWN_SYNC)
                return
            }

            guard sentences.isEmpty == false else {
                ratingView.isHidden = false
                ratingView.title = syncingText
                ratingView.isEnabled = false
                ratingView.doubleMsgViewIsHidden = true
                ratingView.singleMsgViewIsHidden = false
                completion(ratingView, tbv)
                requestSynchronization(.MY_TO_BE_VISION_TRACKER, .DOWN_SYNC)
                return
            }

            for sentence in sentences {
                if visionText.contains(sentence) == false { // mismatched sentences.
                    ratingView.isHidden = false
                    ratingView.title = syncingText
                    ratingView.isEnabled = false
                    ratingView.doubleMsgViewIsHidden = true
                    ratingView.singleMsgViewIsHidden = false
                    completion(ratingView ,tbv)
                    requestSynchronization(.MY_TO_BE_VISION_TRACKER, .DOWN_SYNC)
                    return
                }
            }

            guard let report = ratingReport, report.days.isEmpty == false else {
                ratingView.isHidden = false
                ratingView.title = notRatedText
                ratingView.isEnabled = true
                ratingView.doubleMsgViewIsHidden = true
                ratingView.singleMsgViewIsHidden = false
                completion(ratingView ,tbv)
                return
            }

            guard let date = report.days.sorted().last?.beginingOfDate() else {
                ratingView.isHidden = false
                ratingView.title = syncingText
                ratingView.isEnabled = false
                ratingView.doubleMsgViewIsHidden = true
                ratingView.singleMsgViewIsHidden = false
                completion(ratingView ,tbv)
                return
            }
            let days = DateComponentsFormatter.numberOfDays(date)
            ratingView.isHidden = false
            ratingView.title = self.dateString(for: days)
            ratingView.isEnabled = true
            ratingView.doubleMsgViewIsHidden = false
            ratingView.singleMsgViewIsHidden = true
            completion(ratingView ,tbv)            
        }
    }

    private func dateString(for day: Int) -> String {
        switch day {
        case 0: return "Today"
        case 1: return "Yesterday"
        default: return String(day) + " Days"
        }
    }
}

//completion(myVision, rateText, doubleMsgViewIsHidden, rateEnabled)
class TBVRatingView {
    var title: String
    var isEnabled: Bool
    var isHidden: Bool
    var doubleMsgViewIsHidden: Bool
    var singleMsgViewIsHidden: Bool

    init() {
        self.title = ""
        self.isEnabled = false
        self.isHidden = true
        self.doubleMsgViewIsHidden = true
        self.singleMsgViewIsHidden = true
    }
}
