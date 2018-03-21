//
//  PartnersWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersWorker {

    enum Result {
        case success(Share.EmailContent)
        case failure(Error)
    }

    let services: Services
    let syncManager: SyncManager
    let networkManager: NetworkManager

    init(services: Services, syncManager: SyncManager, networkManager: NetworkManager) {
        self.services = services
        self.syncManager = syncManager
        self.networkManager = networkManager
    }

    func partners() -> [Partners.Partner] {
        let realmPartners = services.partnerService.lastModifiedPartnersSortedByCreatedAtAscending(maxCount: 3)
        var partners = realmPartners.filter { $0.isValid }.map { Partners.Partner($0) }
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
                guard partner.isValid else { continue }
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

    func invitePartner(partner: Partners.Partner, completion: @escaping ((_ emailContent: Result) -> Void)) {
        emailContent(sharingType: .invite, partner: partner, completion: completion)
    }
}

// MARK: - Private

private extension PartnersWorker {

    private func emailContent(sharingType: Partners.SharingType,
                              partner: Partners.Partner,
                              completion: @escaping ((Result) -> Void)) {
        let realm = self.services.mainRealm
        if let partner = realm.syncableObject(ofType: Partner.self, localID: partner.localID),
            let remoteID = partner.remoteID.value {
            self.networkManager
                .performPartnerSharingRequest(partnerID: remoteID, sharingType: sharingType) { (result) in
                    switch result {
                    case .success(let value):
                        let content = Share.EmailContent(email: partner.email,
                                                         subject: value.subject,
                                                         body: value.body)
                        completion(.success(content))
                    case .failure(let error):
                        completion(.failure(error))
                    }
            }
        } else {
            completion(.failure(SimpleError(localizedDescription: "Partner has no remote ID")))
        }
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
