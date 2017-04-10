//
//  ContentCategoryData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation

public protocol ContentCategoryData {
    var sortOrder: Int { get }
    var title: String { get }
    var radius: Double { get }
    var centerX: Double { get }
    var centerY: Double { get }
}
