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

    private let dispatchGroup = DispatchGroup()
    private var headlineText: String?
    private var messageText: String?
    private var notRatedText: String? = ""
    private var syncingText: String? = ""
    private var toBeVision: QDMToBeVision?
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
        getHeadlinePlaceholder()
        getMessagePlaceHolder()
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

    var messagePlaceholder: String? {
        return messageText
    }

    var headlinePlaceholder: String? {
        return headlineText?.uppercased()
    }

    private func getHeadlinePlaceholder() {
        contentService.getContentItemById(101080) {[weak self] (item) in
            self?.headlineText = item?.valueText
        }
    }

    private func getMessagePlaceHolder() {
        contentService.getContentItemById(101079) {[weak self] (item) in
            self?.messageText = item?.valueText
        }
    }

    func getData(_ completion: @escaping() -> Void) {
        myToBeVision()
        getRatingReport()
        getSyncingText()
        getNotRatedText()
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.getVisionTracks {
                completion()
            }
        }
    }

    private func myToBeVision() {
        dispatchGroup.enter()
        userService.getMyToBeVision({ [weak self] (vision, initilized, error) in
            self?.toBeVision = vision
            self?.dispatchGroup.leave()
        })
    }

    private func getRatingReport() {
        dispatchGroup.enter()
        userService.getToBeVisionTrackingReport(last: 1) {[weak self] (report) in
            self?.report = report
            self?.dispatchGroup.leave()
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

    func getSyncingText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyVision.syncingtext.predicate) {[weak self] (contentItem) in
            self?.syncingText = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func getNotRatedText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyVision.notRatedText.predicate) {[weak self] (contentItem) in
            self?.notRatedText = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func updateRateButton() -> (String?, Bool, Bool) {
        guard let tracks = self.tracks, tracks.count > 0 else {
            return (syncingText, true, false)
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
