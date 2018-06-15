//
//  PartnerEditWorker.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditWorker {

    // MARK: - Public

    enum Result {
        case success(Share.EmailContent)
        case failure(Error)
    }

    // MARK: - Properties

    private let services: Services
    private let syncManager: SyncManager
    private let networkManager: NetworkManager
    private let partner: Partners.Partner

    init(services: Services, syncManager: SyncManager, networkManager: NetworkManager, partner: Partners.Partner) {
        self.services = services
        self.syncManager = syncManager
        self.networkManager = networkManager
        self.partner = partner
    }

    var partnerToEdit: Partners.Partner {
        return partner
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

    func savePartner(_ partner: Partners.Partner, completion: ((Error?) -> Void)? = nil) {
        do {
            let realm = try services.realmProvider.realm()
            guard partner.isValid == true else { return }
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
        } catch {
            log("Failed to save partners with error: \(error)")
        }

        syncManager.syncPartners(completion: completion)
    }

    func saveImage(_ image: UIImage) throws -> URL {
        return try image.save(withName: UUID().uuidString)
    }

    func deletePartner(_ partner: Partners.Partner, completion: ((Error?) -> Void)? = nil) {
        do {
            let realm = try services.realmProvider.realm()
            guard partner.isValid == true else { return }
            if let existing = realm.syncableObject(ofType: Partner.self, localID: partner.localID) {
                try realm.write {
                    existing.delete()
                }
            }
        } catch {
            log("Failed to delete partner with error: \(error)")
            completion?(error)
            return
        }
        syncManager.syncPartners(completion: completion)
    }
}

// MARK: - Email Content

private extension PartnerEditWorker {

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

extension Partners.Partner {

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
