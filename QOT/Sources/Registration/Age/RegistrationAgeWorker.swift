//
//  RegistrationAgeWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationAgeWorker: BaseSigningWorker {

    // MARK: - Properties

    lazy var title: String = {
        return AppTextService.get(AppTextKey.create_account_birth_year_view_title)
    }()

    lazy var agePlaceholder: String = {
        return AppTextService.get(AppTextKey.create_account_birth_year_view_placeholder_title)
    }()

    lazy var descriptionText: String = {
        return AppTextService.get(AppTextKey.create_account_birth_year_view_description_title)
    }()

    lazy var ageRestrictionText: String = {
        return AppTextService.get(AppTextKey.create_account_birth_year_view_restriction_title)
    }()

    lazy var nextButtonTitle: String = {
        return AppTextService.get(AppTextKey.create_account_birth_year_view_next_title)
    }()

    // MARK: - Init

    init() {
    }
}
