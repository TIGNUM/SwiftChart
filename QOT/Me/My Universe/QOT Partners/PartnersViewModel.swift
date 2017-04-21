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
    var selectedIndex: Index
    private var currentEditPartner: Partner?

    init(items: [Partner], selectedIndex: Index) {
        self.items = items
        self.selectedIndex = selectedIndex
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> Partner {
        return items[index]
    }

    func didSelectEditPartner() {
        let partnerToEdit = item(at: selectedIndex)

        currentEditPartner = MockPartner(
            localID: partnerToEdit.localID,
            profileImage: partnerToEdit.profileImage,
            name: partnerToEdit.name,
            surename: partnerToEdit.surename,
            relationShip: partnerToEdit.relationShip,
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
        partnerToUpdate.relationShip = updatedPartner.relationShip
        partnerToUpdate.email = updatedPartner.email

        currentEditPartner = nil
    }
}
