//
//  FromMyCoachCellViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class FromMyCoachCellViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var detail: FromMyCoachDetail
    var messages: [FromMyCoachMessage]

    struct FromMyCoachDetail {
        let imageUrl: URL?
        let title: String
    }

    struct FromMyCoachMessage {
        let date: String
        let text: String
    }

    // MARK: - Init
    init(detail: FromMyCoachDetail, messages: [FromMyCoachMessage], image: String?, domainModel: QDMDailyBriefBucket?) {
        self.detail = detail
        self.messages = messages
        super.init(domainModel,
                   caption: AppTextService.get(.daily_brief_section_from_my_tignum_coach_card_title),
                   title: detail.title,
                   body: messages.first?.text,
                   image: image)
    }
}
