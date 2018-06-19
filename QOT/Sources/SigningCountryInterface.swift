//
//  SigningCountryInterface.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol SigningCountryViewControllerInterface: class {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func hideErrorMessage()
    func activateButton(_ active: Bool)
    func endEditing()
    func tableViewReloadData()
}

protocol SigningCountryPresenterInterface {
    func setup()
    func reload(errorMessage: String?, buttonActive: Bool)
    func hideErrorMessage()
    func activateButton(_ active: Bool)
    func endEditing()
    func tableViewReloadData()
}

protocol SigningCountryInteractorInterface: SigningInteractor {
    func numberOfRows() -> Int
    func country(at indexPath: IndexPath) -> String
    func setSelectedCountry(countryName: String)
    var countryQuery: String { get }
}

protocol SigningCountryRouterInterface {
    func showProfileDetailsView(email: String, code: String, password: String, country: UserCountry)
}
