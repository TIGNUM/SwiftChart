//
//  ShareWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersWorker {

    let services: Services
    let syncManager: SyncManager

    init(services: Services, syncManager: SyncManager) {
        self.services = services
        self.syncManager = syncManager
    }

    func partners() -> [Partners.Partner] {
        let realmPartners = services.partnerService.lastModifiedPartnersSortedByCreatedAtAscending(maxCount: 3)
        var partners = realmPartners.map { Partners.Partner($0) }
        for _ in partners.count..<3 {
            // Pad with empty partners
            partners.append(Partners.Partner())
        }
        return partners
    }

    func savePartners(_ partners: [Partners.Partner]) {
        do {
            let realm = try services.realmProvider.realm()
            for partner in partners {
                if let existing = realm.syncableObject(ofType: Partner.self, localID: partner.localID) {
                    try realm.write {
                        existing.update(partner)
                    }
                } else {
                    let new = Partner()
                    try realm.write {
                        realm.add(new)
                        new.update(partner)
                    }
                }
            }
        } catch {
            log("Failed to save partners with error: \(error)")
        }
        syncManager.syncAll(shouldDownload: false)
        syncManager.uploadMedia()
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }
}

private extension Partners.Partner {

    convenience init() {
        self.init(localID: UUID().uuidString,
                  name: nil,
                  surname: nil,
                  relationship: nil,
                  email: nil,
                  imageURL: nil)
    }

    convenience init(_ realmPartner: Partner) {
        self.init(localID: realmPartner.localID,
                  name: realmPartner.name,
                  surname: realmPartner.surname,
                  relationship: realmPartner.relationship,
                  email: realmPartner.email,
                  imageURL: realmPartner.profileImageResource?.url)
    }
}

private extension Partner {

    func update(_ partner: Partners.Partner) {
        guard partner != Partners.Partner(self),
            let name = partner.name,
            let surname = partner.surname,
            let email = partner.email else { return }

        self.name = name
        self.surname = surname
        self.relationship = partner.relationship
        self.email = email
        // Only update imageURL if necessary otherwise will need to upload
        if let imageURL = partner.imageURL,
            imageURL != profileImageResource?.url,
            imageURL.baseURL == URL.imageDirectory {
            self.profileImageResource?.setLocalURL(imageURL, format: .jpg, entity: .partner, entitiyLocalID: localID)
        }
        didUpdate()
    }
}
