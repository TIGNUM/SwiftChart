//
//  PartnersViewModel.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class PartnersViewModel {

    // MARK: - Properties

    let items: [Partner]
    let headline: String
    private var selectedIndex: Index
    fileprivate var currentEditPartner: Partner?

    init(items: [Partner], selectedIndex: Index, headline: String) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.headline = headline.uppercased()
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> Partner {
        return items[index]
    }

    func updateIndex(index: Index) {
        selectedIndex = index
        saveCurrentEditPartnerIfNeeded()
    }

    func updateName(name: String) {
        currentEditPartner?.name = name
    }

    func updateSurename(surename: String) {
        currentEditPartner?.surename = surename
    }

    func updateRelationship(relationship: String) {
        currentEditPartner?.relationship = relationship
    }

    func updateEmail(email: String) {
        currentEditPartner?.email = email
    }

    func didSelectEditPartner() {
        let partnerToEdit = item(at: selectedIndex)

        currentEditPartner = MockPartner(
            localID: partnerToEdit.localID,
            profileImage: partnerToEdit.profileImage,
            name: partnerToEdit.name,
            surename: partnerToEdit.surename,
            relationship: partnerToEdit.relationship,
            email: partnerToEdit.email
        )
    }

    func didTapSaveChanges() {
        guard let updatedPartner = currentEditPartner else {
            return
        }

        var partnerToUpdate = item(at: selectedIndex)
        partnerToUpdate.profileImage = updatedPartner.profileImage
        partnerToUpdate.name = updatedPartner.name
        partnerToUpdate.surename = updatedPartner.surename
        partnerToUpdate.relationship = updatedPartner.relationship
        partnerToUpdate.email = updatedPartner.email

        currentEditPartner = nil
    }
}

// MARK: - Private Methods

private extension PartnersViewModel {

    func saveCurrentEditPartnerIfNeeded() {
        guard currentEditPartner != nil else {
            return
        }

        didTapSaveChanges()
        didSelectEditPartner()
    }
}
