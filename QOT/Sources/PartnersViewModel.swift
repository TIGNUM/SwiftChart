//
//  PartnersViewModel.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class PartnersViewModel {
    
    // MARK: - Properties

    var items: [PartnerValue?]
    let headline: String
    private(set) var selectedIndex: Index
    fileprivate var currentEditPartner: PartnerValue?

    init(services: Services, selectedIndex: Index, headline: String) {
        let maxPartners = Layout.MeSection.maxPartners
        self.items = Array(services.partnerService.partnerValues.prefix(maxPartners))
        for _ in 0..<(maxPartners - items.count) { // pad default items with placeholders
            self.items.append(nil)
        }
        self.selectedIndex = selectedIndex
        self.headline = headline.uppercased()
    }

    var itemCount: Int {
        return items.count
    }
    
    func item(at index: Index) -> PartnerValue? {
        return items[index]
    }

    func updateIndex(index: Index) {
        save()
        selectedIndex = index
        currentEditPartner = item(at: index) ?? PartnerValue(
            localID: UUID().uuidString,
            profileImageURL: nil,
            name: nil,
            surname: nil,
            relationship: nil,
            email: nil)
    }

    func updateName(name: String) {
        currentEditPartner?.name = name
    }

    func updateSurname(surname: String) {
        currentEditPartner?.surname = surname
    }
    
    func updateRelationship(relationship: String) {
        currentEditPartner?.relationship = relationship
    }

    func updateEmail(email: String) {
        currentEditPartner?.email = email
    }

    func updateProfileImage(image: UIImage) -> Error? {
        guard let localID = currentEditPartner?.localID else {
            return nil
        }
        do {
            let url = try image.save(withName: localID)
            currentEditPartner?.profileImageURL = url.absoluteString
            return nil
        } catch {
            return error
        }
    }

    func save() {
        guard let updatedPartner = currentEditPartner else {
            return
        }
        items[selectedIndex] = updatedPartner
    }
}
