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

enum DatabaseError: Error {
    case noLayoutInfo
    case objectNotFound(primaryKey: Any)
}

struct SimpleError: Error {
    let localizedDescription: String
}
