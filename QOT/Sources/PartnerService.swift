//
//  PartnerService.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

final class PartnerService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    // FIXME: Delete me when possible
    var partners: AnyRealmCollection<Partner> {
        let results = mainRealm.objects(Partner.self)
        return AnyRealmCollection(results)
    }

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func lastModifiedPartnersSortedByCreatedAtAscending(maxCount: Int) -> [Partner] {
        do {
            let unsorted = try self.realmProvider.realm().objects(Partner.self).sorted(byKeyPath: "modifiedAt").suffix(maxCount)
            return unsorted.sorted { (first, second) -> Bool in
                return first.createdAt < second.createdAt
            }
        } catch {
            // Do nothing
        }
        return []
    }

    func createPartner() throws -> Partner {
        let partner = Partner()
        partner.didUpdate()
        try mainRealm.write {
            mainRealm.add(partner)
        }
        return partner
    }

    func updateName(partner: Partner, name: String) {
        updatePartner(partner) {
            $0.name = name
        }
    }

    func updateSurname(partner: Partner, surname: String) {
        updatePartner(partner) {
            $0.surname = surname
        }
    }

    func updateRelationship(partner: Partner, relationship: String) {
        updatePartner(partner) {
            $0.relationship = relationship
        }
    }

    func updateEmail(partner: Partner, email: String) {
        updatePartner(partner) {
            $0.email = email
        }
    }

    func updatePartner(_ partner: Partner, block: (Partner) -> Void) {
        do {
            try mainRealm.write {
                block(partner)
                partner.didUpdate()
            }
        } catch let error {
            assertionFailure("Update \(Partner.self), error: \(error)")
        }
    }

    func eraseData() {
        do {
            try mainRealm.write {
                mainRealm.delete(partners)
            }
        } catch {
            assertionFailure("Failed to delete partners with error: \(error)")
        }
    }
}
