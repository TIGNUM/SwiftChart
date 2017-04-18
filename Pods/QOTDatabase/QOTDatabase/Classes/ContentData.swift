//
//  ContentData.swift
//  Pods
//
//  Created by Sam Wyndham on 06/04/2017.
//
//

import Foundation

public protocol ContentData {
    var sortOrder: Int { get }
    var title: String { get }
}
