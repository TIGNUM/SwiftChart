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

    private var headlineText: String?
    private var messageText: String?
    private var toBeVision: QDMToBeVision?
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

    func myToBeVision(_ completion: @escaping (_ vision: QDMToBeVision?, _ initialized: Bool, Error?) -> Void) {
        userService.getMyToBeVision({ [weak self] (vision, initilized, error) in
            self?.toBeVision = vision
            completion(vision, initilized, error)
        })
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

    func lastUpdatedVision() -> String? {
        guard let date =  toBeVision?.date,
            let timeInterval = DateComponentsFormatter.timeIntervalToString(-date.timeIntervalSinceNow, isShort: true) else { return nil }
        return timeInterval
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
}
