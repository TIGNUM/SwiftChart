//
//  PreparationWithMissingEventWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PreparationWithMissingEventWorker {

    // MARK: - Properties
    var preparations = [QDMUserPreparation]()
    var currentIndex: Int = 0
    private var title: String = ""
    private var text: String = ""
    private var _keepButtonTitle: String = ""
    private var _removeButtonTitle: String = ""

    // MARK: - Init

    init(preparations: [QDMUserPreparation]) {
        self.preparations = preparations
        self.title = ScreenTitleService.main.localizedString(for: .missingEventForPrepationPopUpTitle)
        self.text = ScreenTitleService.main.localizedString(for: .missingEventForPrepationPopUpDescription)
        self._keepButtonTitle = ScreenTitleService.main.localizedString(for: .missingEventForPrepationPopUpKeepButtonTitle)
        self._removeButtonTitle = ScreenTitleService.main.localizedString(for: .missingEventForPrepationPopUpRemoveButtonTitle)
    }

    func keepPreparation(preparation: QDMUserPreparation) {
        var prep = preparation
        prep.keepWithMissingEvent = true
        self.currentIndex += 1
        UserService.main.updateUserPreparation(prep) { (_, _) in
        }
    }

    func deletePreparation(preparation: QDMUserPreparation) {
        self.currentIndex += 1
        UserService.main.deleteUserPreparation(preparation) { (_) in
        }
    }

    func updatePreparation(preparation: QDMUserPreparation, with newEvent: QDMUserCalendarEvent) {
        self.currentIndex += 1
        UserService.main.updateUserPreparation(preparation, newEvent: newEvent) { (_, _) in
        }
    }

    func nextPreparation() -> QDMUserPreparation? {
        guard currentIndex < self.preparations.count else { return nil }
        return self.preparations[currentIndex]
    }

    func events(_ completion: @escaping ([QDMUserCalendarEvent]) -> Void) {
        CalendarService.main.getCalendarEvents(from: Date().beginingOfDate()) { (events, _, _) in
            completion(events ?? [])
        }
    }

    func titleFor(_ preparation: QDMUserPreparation) -> String {
        return replacePreparationText(title)
    }

    func textFor(_ preparation: QDMUserPreparation) -> String {
        return replacePreparationText(text)
    }

    func removeButtonTitle() -> String {
        return _removeButtonTitle
    }

    func keepButtonTitle() -> String {
        return _keepButtonTitle
    }

    private func replacePreparationText(_ from: String) -> String {
        let eventDate = preparations[currentIndex].eventDate
        let eventTitle = preparations[currentIndex].eventTitle
        return from.replacingOccurrences(of: "${EVENT_DATE}", with: Prepare.dateString(for: eventDate) ?? "-")
            .replacingOccurrences(of: "${EVENT_TITLE}", with: eventTitle ?? "-")
    }
}
