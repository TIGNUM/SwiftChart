//
//  SyncTask.swift
//  QOT
//
//  Created by Sam Wyndham on 18.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol SyncTask {
    func start(completion: @escaping (SyncError?) -> Void)
    func cancel()
}
