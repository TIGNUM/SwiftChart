//
//  ContentItemData.swift
//  Pods
//
//  Created by Sam Wyndham on 07/04/2017.
//
//

import Foundation

public protocol ContentItemData {
    var sortOrder: Int { get }
    var title: String { get }
    var secondsRequired: Int { get }
    var value: ContentItemValue { get }
    var status: ContentItemStatus { get }
}


// FIXME: Unit test
public enum ContentItemValue {
    enum Error: Swift.Error {
        case invalid(format: Int8, value: String)
    }

    case text(String)
    case video(URL)

    init(format: Int8, value: String) throws {
        switch format {
        case Key.text.rawValue:
            self = .text(value)
        case Key.video.rawValue:
            guard let url = URL(string: value) else { throw Error.invalid(format: format, value: value) }
            self = .video(url)
        default:
            throw Error.invalid(format: format, value: value)
        }
    }

    private enum Key: Int8 {
        case text = 0
        case video = 1
    }

    var format: Int8 {
        switch self {
        case .text:
            return Key.text.rawValue
        case .video:
            return Key.video.rawValue
        }
    }

    var value: String {
        switch self {
        case .text(let value):
            return value
        case .video(let url):
            return url.absoluteString
        }
    }
}

// FIXME: Unit test
public enum ContentItemStatus: Int8 {
    case notViewed = 0
    case viewed = 1
}
