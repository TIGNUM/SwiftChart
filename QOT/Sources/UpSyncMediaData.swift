//
//  UpSyncMediaData.swift
//  QOT
//
//  Created by Lee Arromba on 08/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

struct UpSyncMediaData {
    
    let body: Data
    
    init(body: Data) {
        self.body = body
    }
}
