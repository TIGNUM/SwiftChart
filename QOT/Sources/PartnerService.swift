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
 
    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }
    
    func partners() -> AnyRealmCollection<Partner> {
        let results = mainRealm.objects(Partner.self)
        return AnyRealmCollection(results)
    }
    
    func create(success: ((Partner?) -> Void)?, failure: ((Error?) -> Void)?) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let partner = realm.create(Partner.self, value: Partner(), update: true)
                    DispatchQueue.main.async {
                        success?(partner)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }
    
    func update(_ partners: [PartnerIntermediary], completion: ((Error?) -> Void)?) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    partners.forEach({ (p: PartnerIntermediary) in
                        let partner = Partner(
                            localID: p.localID,
                            name: p.name,
                            surname: p.surname,
                            relationship: p.relationship,
                            email: p.email,
                            profileImageURL: p.profileImageURL)
                        realm.add(partner, update: true)
                    })
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }
}
