//
//  MyVisionWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionWorker: WorkerTeam {

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
    private lazy var notRatedText = AppTextService.get(.my_qot_my_tbv_section_track_null_state_title)
    private lazy var syncingText = AppTextService.get(.my_qot_my_tbv_loading_body_syncing)
    private lazy var widgetDataManager = ExtensionsDataManager()
    private var toBeVision: QDMToBeVision?
    private var isMyVisionInitialized: Bool = false
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

    func getToBeVision(_ completion: @escaping (_ initialized: Bool, _ toBeVision: QDMToBeVision?) -> Void) {
        UserService.main.getMyToBeVision { [weak self] (vision, initialized, _) in
            self?.toBeVision = vision
            self?.isMyVisionInitialized = initialized
            completion(initialized, vision)
        }
    }

    func getVisionTracks(_ completion: @escaping ([QDMToBeVisionTrack]) -> Void) {
        UserService.main.getToBeVisionTracksForRating { (tracks) in
            completion(tracks)
        }
    }

    func updateMyToBeVision(_ new: QDMToBeVision, completion: @escaping (_ toBeVision: QDMToBeVision?) -> Void) {
        UserService.main.updateMyToBeVision(new) { [weak self] error in
            self?.getToBeVision { [weak self] (_, qdmVision) in
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

    func getRateButtonValues(_ completion: @escaping (String?, Bool?, Bool) -> Void) {
        getRatingReport { [weak self] (report) in
            self?.getVisionTracks { [weak self] (tracks) in
                guard let strongSelf = self else { return }

                guard let visionText = strongSelf.toBeVision?.text,
                    !tracks.isEmpty else {
                    completion(strongSelf.syncingText, nil, false)
                    return
                }
                let sentences = tracks.compactMap({$0.sentence})
                guard !sentences.isEmpty else {
                    completion(strongSelf.syncingText, nil, false)
                    requestSynchronization(.MY_TO_BE_VISION_TRACKER, .DOWN_SYNC)
                    return
                }

                for sentence in sentences {
                    if visionText.contains(sentence) == false { // mismatched sentences.
                        completion(strongSelf.syncingText, nil, false)
                        requestSynchronization(.MY_TO_BE_VISION_TRACKER, .DOWN_SYNC)
                        return
                    }
                }

                guard let report = report, report.days.count > 0 else {
                    completion(strongSelf.notRatedText, true, true)
                    return
                }
                guard let date = report.days.sorted().last?.beginingOfDate() else {
                    completion(strongSelf.syncingText, true, false)
                    return
                }
                let days = DateComponentsFormatter.numberOfDays(date)
                completion(strongSelf.dateString(for: days), false, true)
            }
        }
    }
}
