//
//  SigningProfileDetailInterface.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningProfileDetailViewControllerInterface: class {
    func setup()
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningProfileDetailPresenterInterface {
    func setup()
    func activateButton(_ active: Bool)
    func endEditing()
}

protocol SigningProfileDetailInteractorInterface: SigningInteractor {
    var email: String? { get }
    var code: String? { get }
    var password: String? { get }
    var country: UserCountry? { get }
    var firstName: String? { get }
    var lastName: String? { get }
    var gender: String? { get }
    var dateOfBirth: String? { get }
    func updateFirstName(_ firstName: String)
    func updateLastName(_ lastName: String)
    func updateGenderName(_ gender: String)
    func updateDateOfBirth(_ dateOfBirth: String)
    func updateCheckBox(_ isChecked: Bool)
    func showTermsOfUse()
    func showPrivacyPolicy()
}

protocol SigningProfileDetailRouterInterface {
    func showTermsOfUse()
    func showPrivacyPolicy()
    func showAlert(message: String)
    func handleError(_ error: Error?)
}
