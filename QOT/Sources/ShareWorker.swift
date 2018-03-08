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

    init(services: Services,
         partnerLocalID: String,
         networkManager: NetworkManager,
         syncManager: SyncManager,
         name: String) {
        self.services = services
        self.partnerLocalID = partnerLocalID
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.name = name
    }

    func shareToBeVisionEmailContent(completion: @escaping ((_ emailContent: Result) -> Void)) {
        emailContent(sharingType: .toBeVision, completion: completion)
    }

    func shareWeeklyChoicesEmailContent(completion: @escaping ((_ emailContent: Result) -> Void)) {
        emailContent(sharingType: .weeklyChoices, completion: completion)
    }

    private func emailContent(sharingType: Partners.SharingType,
                              completion: @escaping ((Result) -> Void)) {
        syncManager.syncAll(shouldDownload: false) { [weak self] (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let `self` = self else { return }
                let realm = self.services.mainRealm
                if let partner = realm.syncableObject(ofType: Partner.self, localID: self.partnerLocalID),
                    let remoteID = partner.remoteID.value {
                    self.networkManager.performPartnerSharingRequest(partnerID: remoteID,
                                                                     sharingType: sharingType) { (result) in
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
    }
}
