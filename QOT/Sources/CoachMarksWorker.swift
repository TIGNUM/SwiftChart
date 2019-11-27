//
//  CoachMarksWorker.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CoachMarksWorker {
    func getContentCategory(_ contentCategoryId: Int, _ completion: @escaping (QDMContentCategory?) -> Void) {
        ContentService.main.getContentCategoryById(contentCategoryId, completion)
    }

    func saveCoachMarksViewed() {
        guard let email = SessionService.main.getCurrentSession()?.useremail else { return }
        var emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
        emails.append(email)
        UserDefault.didShowCoachMarks.setObject(emails)
    }
}
