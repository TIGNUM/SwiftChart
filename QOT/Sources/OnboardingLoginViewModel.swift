//
//  OnboardingLoginViewModel.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 05/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct OnboardingLoginViewModel {
    var emailError: String?
    var emailResponseCode: ApiResponseResult?
    var sendCodeEnabled: Bool = true
    var codeError: String?
}
