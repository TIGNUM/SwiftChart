//
//  Syncable.swift
//  QOT
//
//  Created by Sam Wyndham on 17.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol Syncable: class {

    static var endpoint: Endpoint { get }
}
