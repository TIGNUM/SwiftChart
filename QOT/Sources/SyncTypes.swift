//
//  SyncTypes.swift
//  QOT
//
//  Created by Sam Wyndham on 02.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

// TODO: typealias TwoWaySyncableCreatedRemoteOnly = DownSyncable &
typealias TwoWaySyncable = DownSyncable & UpSyncableWithLocalAndRemoteIDs
typealias OneWaySyncableDown = DownSyncable
typealias OneWaySyncableUp = UpSyncableDeleting
typealias TwoWaySyncableUniqueObject = DownSyncable & UpsyncableUnique
