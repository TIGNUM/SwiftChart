//
//  RegistrationAgeInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegistrationAgeViewControllerInterface: class {
    func setupView()
}

protocol RegistrationAgePresenterInterface {
    func setupView()
}

protocol RegistrationAgeInteractorInterface: Interactor {
    var title: String { get }
    var agePlaceholder: String { get }
    var descriptionText: String { get }
    var ageRestrictionText: String { get }
    var createButtonTitle: String { get }

    func didTapBack()
    func didTapNext(with birthYear: String)
}

protocol RegistrationAgeRouterInterface {}
