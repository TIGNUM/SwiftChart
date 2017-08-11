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

    let headline: String
    private var items: [Partner?]
    private var services: Services
    private var partnerService: PartnerService {
        return services.partnerService
    }
    private var mediaService: MediaService {
        return services.mediaService
    }
    private(set) var selectedIndex: Index
    private var currentEditPartner: Partner?

    init(services: Services, selectedIndex: Index, headline: String) {
        self.services = services
        self.selectedIndex = selectedIndex
        self.headline = headline.uppercased()
        
        let maxPartners = Layout.MeSection.maxPartners
        self.items = Array(services.partnerService.partners.prefix(maxPartners))
        for _ in 0..<(maxPartners - items.count) { // pad default items with placeholders
            self.items.append(nil)
        }
    }

    var itemCount: Int {
        return items.count
    }
    
    func item(at index: Index) -> Partner? {
        return items[index]
    }

    func updateIndex(index: Index) {
        save()
        selectedIndex = index
        
        if let partner = item(at: index) {
            currentEditPartner = partner
        } else {
            do {
                currentEditPartner = try partnerService.createPartner()
            } catch {}
        }
    }

    func updateName(name: String) {
        guard let currentEditPartner = currentEditPartner else { return }
        partnerService.updateName(partner: currentEditPartner, name: name)
    }

    func updateSurname(surname: String) {
        guard let currentEditPartner = currentEditPartner else { return }
        partnerService.updateSurname(partner: currentEditPartner, surname: surname)
    }
    
    func updateRelationship(relationship: String) {
        guard let currentEditPartner = currentEditPartner else { return }
        partnerService.updateRelationship(partner: currentEditPartner, relationship: relationship)
    }

    func updateEmail(email: String) {
        guard let currentEditPartner = currentEditPartner else { return }
        partnerService.updateEmail(partner: currentEditPartner, email: email)
    }

    func updateProfileImage(image: UIImage) -> Error? {
        guard
            let currentEditPartner = currentEditPartner,
            let profileImageResource = currentEditPartner.profileImageResource else {
            return nil
        }
        do {
            let url = try image.save(withName: currentEditPartner.localID)
            mediaService.updateLocalURLString(mediaResource: profileImageResource, localURLString: url.absoluteString)
            NotificationCenter.default.post(name: .startSyncAllNotification, object: nil)
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
