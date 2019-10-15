//
//  WalkthroughWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class WalkthroughWorker {

    // MARK: - Properties
    let selectedTrack: SelectedTrackType

    // MARK: - Init

    init(selectedTrack: SelectedTrackType) {
        self.selectedTrack = selectedTrack
    }

    func saveViewedWalkthrough() {
        guard let email = SessionService.main.getCurrentSession()?.useremail else { return }
        var emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
        emails.append(email)
        UserDefault.didShowCoachMarks.setObject(emails)
    }

    // Texts
    var buttonGotIt: String = {
        return AppTextService.get(AppTextKey.walkthrough_view_button_got_it)
    }()
}
