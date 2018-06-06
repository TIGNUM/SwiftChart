//
//  ShareWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class ShareWorker {

    enum Result {
        case success(Share.EmailContent)
        case failure(Error)
    }

    let services: Services
    let partnerLocalID: String
    let networkManager: NetworkManager
    let syncManager: SyncManager
    let name: String
    let surname: String
    let imageURL: URL?
    let relationship: String
    let email: String
    let initials: String
    var sharingType: Partners.SharingType?

    init(services: Services,
         partnerLocalID: String,
         networkManager: NetworkManager,
         syncManager: SyncManager,
         name: String,
         surname: String,
         relationship: String,
         email: String,
         imageURL: URL?,
         initials: String) {
        self.services = services
        self.partnerLocalID = partnerLocalID
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.name = name
        self.surname = surname
        self.relationship = relationship
        self.email = email
        self.imageURL = imageURL
        self.initials = initials
    }

    func shareToBeVisionEmailContent(completion: @escaping ((_ emailContent: Result) -> Void)) {
        emailContent(sharingType: .toBeVision, completion: completion)
    }

    func shareWeeklyChoicesEmailContent(completion: @escaping ((_ emailContent: Result) -> Void)) {
        emailContent(sharingType: .weeklyChoices, completion: completion)
    }

    func preUpSyncData() {
        preUpSyncData(completion: nil)
    }

    private func preUpSyncData(completion: ((Error?) -> Void)?) {
        syncManager.syncForSharing(completion: completion)
    }

    private func emailContent(sharingType: Partners.SharingType, completion: @escaping ((Result) -> Void)) {
        preUpSyncData(completion: { [weak self] (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let `self` = self else { return }
                let realm = self.services.mainRealm
                if let partner = realm.syncableObject(ofType: Partner.self, localID: self.partnerLocalID),
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
        })
    }
}
