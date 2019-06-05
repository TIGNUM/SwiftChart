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

    private var toBeVision: QDMToBeVision?
    private let services: Services
    let permissionManager: PermissionsManager
    private let widgetDataManager: ExtensionsDataManager
    var toBeVisionDidChange: ((QDMToBeVision?) -> Void)?
    static var toBeSharedVisionHTML: String?

    init(services: Services, permissionManager: PermissionsManager) {
        self.services = services
        self.permissionManager = permissionManager
        self.widgetDataManager = ExtensionsDataManager(services: services)

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

    var trackablePageObject: PageObject? {
        return services.userService.myToBeVision().map { PageObject(object: $0, identifier: .myToBeVision) }
    }

    var headlinePlaceholder: String? {
        return services.contentService.toBeVisionHeadlinePlaceholder()?.uppercased()
    }

    var messagePlaceholder: String? {
        return services.contentService.toBeVisionMessagePlaceholder()
    }

    func myToBeVision(_ completion: @escaping (_ vision: QDMToBeVision?, _ initialized: Bool, Error?) -> Void) {
        qot_dal.UserService.main.getMyToBeVision({ [weak self] (vision, initilized, error) in
            self?.toBeVision = vision
            completion(vision, initilized, error)
        })
    }

    func updateMyToBeVision(_ new: QDMToBeVision, completion: @escaping () -> Void) {
        qot_dal.UserService.main.updateMyToBeVision(new) { error in
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
        return R.string.localized.meSectorMyWhyVisionWriteDate(timeInterval)
    }

    func visionToShare(_ completion: @escaping (QDMToBeVisionShare?) -> Void) {
        qot_dal.UserService.main.getMyToBeVisionShareData { (visionShare, initialized, error) in
            MyVisionWorker.toBeSharedVisionHTML = visionShare?.body
            completion(visionShare)
        }
    }

    func setMyToBeVisionReminder(_ remind: Bool) {
        services.userService.setMyToBeVisionReminder(remind)
    }

    func updateWidget() {
        widgetDataManager.update(.toBeVision)
    }
}
