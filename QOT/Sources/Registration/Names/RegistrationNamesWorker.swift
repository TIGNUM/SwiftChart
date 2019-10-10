//
//  RegistrationNamesWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationNamesWorker: BaseSigningWorker {

    // MARK: - Properties

    lazy var title: String = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_title)
    }()

    lazy var firstNameTitle: String = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_first_name_title)
    }()

    lazy var lastNameTitle: String = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_last_name_title)
    }()

    lazy var mandatoryText: String  = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_mandatory_title)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_next_title)
    }()

    // MARK: - Init

    init() {
    }
}
