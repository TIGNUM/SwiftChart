//
//  MediaService.swift
//  QOT
//
//  Created by Lee Arromba on 07/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

class MediaService {
    
    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    
    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }
    
    func updateLocalURLString(mediaResource: MediaResource, localURLString: String?) {
        updateMediaResource(mediaResource) {
            $0.localURLString = localURLString
        }
    }
    
    func updateRemoteURLString(mediaResource: MediaResource, remoteURLString: String?) {
        updateMediaResource(mediaResource) {
            $0.remoteURLString = remoteURLString
        }
    }
    
    func updateMediaResource(_ mediaResource: MediaResource, block: (MediaResource) -> Void) {
        do {
            try mainRealm.write {
                block(mediaResource)
            }
        } catch let error {
            assertionFailure("Update \(MediaResource.self), error: \(error)")
        }
    }
}
