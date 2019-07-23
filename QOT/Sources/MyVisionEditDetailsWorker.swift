//
//  MyVisionEditDetailsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionEditDetailsWorker {

    var visionPlaceholderDescription: String?
    var visionPlaceholderTitle: String?
    let isFromNullState: Bool
    let contentService: qot_dal.ContentService
    let originalTitle: String
    let originalVision: String
    private var myToBeVision: QDMToBeVision?
    private let widgetDataManager: ExtensionsDataManager

    init(title: String, vision: String, widgetManager: ExtensionsDataManager, contentService: qot_dal.ContentService, isFromNullState: Bool = false) {
        originalTitle = title
        self.contentService = contentService
        originalVision = vision
        widgetDataManager = widgetManager
        self.isFromNullState = isFromNullState
        getMyToBeVision()
        getVisionDescription()
        getVisionTitle()
    }

    var firstTimeUser: Bool {
        return myToBeVision == nil
    }

    var myVision: QDMToBeVision? {
        return myToBeVision
    }

    func getMyToBeVision() {
        qot_dal.UserService.main.getMyToBeVision({ [weak self] (vision, initilized, error) in
            self?.myToBeVision = vision
        })
    }

    func updateMyToBeVision(_ toBeVision: QDMToBeVision, _ completion: @escaping (Error?) -> Void) {
        qot_dal.UserService.main.updateMyToBeVision(toBeVision) { error in
            self.updateWidget()
            completion(error)
        }
    }

    func formatPlaceholder(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .sand40)
    }

    func format(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .sand)
    }

    func formatPlaceholder(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .sand40)
    }

    func format(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .sand)
    }

    func updateWidget() {
        widgetDataManager.update(.toBeVision)
    }

    private func getVisionDescription() {
        contentService.getContentItemByPredicate(ContentService.MyVision.visionDescription.predicate) {[weak self] (contentItem) in
            self?.visionPlaceholderDescription = contentItem?.valueText ?? R.string.localized.myToBeVisionTitlePlaceholder()
        }
    }

    private func getVisionTitle() {
        contentService.getContentItemByPredicate(ContentService.MyVision.visionTitle.predicate) {[weak self] (contentItem) in
            self?.visionPlaceholderTitle = contentItem?.valueText ?? R.string.localized.myToBeVisionDescriptionPlaceholder()
        }
    }
}
