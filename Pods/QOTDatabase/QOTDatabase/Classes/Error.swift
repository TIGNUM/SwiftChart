//
//  Error.swift
//  Pods
//
//  Created by Sam Wyndham on 11/04/2017.
//
//

import Foundation

struct InvalidDataError<Data>: Error {
    let data: Data
}

enum QOTDatabaseError: Error {
    case noLayoutInfo
}
