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
        return AppTextService.get(AppTextKey.create_account_user_name_view_title_first_name)
    }()

    lazy var lastNameTitle: String = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_title_last_name)
    }()

    lazy var mandatoryText: String  = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_title_mandatory)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.create_account_user_name_view_title_next)
    }()

    // MARK: - Init

    init() {
    }
}
