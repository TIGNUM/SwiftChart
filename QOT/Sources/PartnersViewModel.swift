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

    var items: [PartnerIntermediary?]
    let headline: String
    private(set) var selectedIndex: Index
    fileprivate var currentEditPartner: PartnerIntermediary?
    
    init(items: [PartnerIntermediary], selectedIndex: Index, headline: String) {
        self.items = items
        for _ in 0..<(Layout.MeSection.maxPartners - items.count) { // pad default items with placeholders
            self.items.append(nil)
        }
        self.selectedIndex = selectedIndex
        self.headline = headline.uppercased()
    }

    var itemCount: Int {
        return items.count
    }
    
    func item(at index: Index) -> PartnerIntermediary? {
        return items[index]
    }

    func updateIndex(index: Index) {
        save()
        selectedIndex = index
        currentEditPartner = item(at: index) ?? PartnerIntermediary(
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
