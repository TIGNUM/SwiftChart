//
//  PeakPerformanceViewModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 22.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PeakPerformanceViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    let contentSubtitle: String?
    let contentSentence: String?
    let eventTitle: String?
    let eventSubtitle: String?
    let qdmUserPreparation: QDMUserPreparation?

    // MARK: - Init
    init(title: String,
         contentSubtitle: String?,
         contentSentence: String?,
         eventTitle: String?,
         eventSubtitle: String?,
         image: String?,
         qdmUserPreparation: QDMUserPreparation?,
         domainModel: QDMDailyBriefBucket?) {
        self.contentSubtitle = contentSubtitle
        self.contentSentence = contentSentence
        self.eventTitle = eventTitle
        self.eventSubtitle = eventSubtitle
        self.qdmUserPreparation = qdmUserPreparation
        super.init(domainModel,
                   caption: title,
                   title: eventTitle,
                   body: eventSubtitle,
                   image: image)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? PeakPerformanceViewModel else {
            return false
        }

        let eventDates = Set(domainModel?.preparations?.compactMap({ $0.eventDate }) ?? [])
        let sourceEventDates = Set(source.domainModel?.preparations?.compactMap({ $0.eventDate }) ?? [])

        let eventTitles = Set(domainModel?.preparations?.compactMap({ $0.eventTitle }) ?? [])
        let sourceEventTitles = Set(source.domainModel?.preparations?.compactMap({ $0.eventTitle }) ?? [])

        return super.isContentEqual(to: source) && eventDates == sourceEventDates && eventTitles == sourceEventTitles
    }
}
