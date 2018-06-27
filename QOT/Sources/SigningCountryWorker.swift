//
//  SigningCountryWorker.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCountryWorker {

    // MARK: - Properties

    private let services: Services
    private let networkManager: NetworkManager
    private var countries = [UserCountry]()
    let email: String
    let code: String
    let password: String
    var countryNames = [String]()
    var countryQuery = ""
    var selectedCountry: UserCountry?

    // MARK: - Init

    init(services: Services,
         networkManager: NetworkManager,
         email: String,
         code: String,
         password: String) {
        self.services = services
        self.networkManager = networkManager
        self.email = email
        self.code = code
        self.password = password
    }
}

extension SigningCountryWorker {

    func fetchCountries(completion: (() -> Void)?) {
        setupCountries(completion: completion)
    }

    func numberOfRows(query: String) -> Int {
        updateCountryNames(query: query)
        return countryNames.count
    }

    func updateCountryQuery(query: String) {
        countryQuery = query
        updateCountryNames(query: query)
    }

    func setSelectedCountry(countryName: String) {
        if countryName.isEmpty == true {
            selectedCountry = nil
        } else {
            selectedCountry = countries.filter { $0.name == countryName }.first
        }
    }
}

// MARK: - Private

private extension SigningCountryWorker {

    func setupCountries(completion: (() -> Void)?) {
        networkManager.performRegistrationCountryRequest { (result) in
            self.countries = result.value?.countries ?? []
            self.updateCountryNames(query: "")
            completion?()
        }
    }

    func updateCountryNames(query: String) {
        if query.isEmpty == true {
            countryNames = countries.compactMap { $0.name }
        } else {
            let filteredCountries = countries.filter { $0.name.lowercased().starts(with: query.lowercased()) ||
                $0.iso2LetterCode.lowercased().starts(with: query.lowercased()) }
            countryNames = (filteredCountries.compactMap { $0.name })
        }
        countryNames = countryNames.sorted()
    }
}
