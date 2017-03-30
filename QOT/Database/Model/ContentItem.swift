//
//  ContentItem.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// FIXME: Unit test once data model is finalized.
final class ContentItem: Object {

    enum Data {
        case text(String)
        case video(URL)
    }
    
    enum Status {
        case notViewed
        case viewed
    }
    
    private dynamic var value: String = ""
    private dynamic var format: String = ""
    private dynamic var _status: String = ""
    
    dynamic var id: Int = 0
    dynamic var sort: Int = 0
    dynamic var title: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, sort: Int, title: String, status: Status, data: ContentItem.Data) {
        self.init()
        self.id = id
        self.sort = sort
        self.title = title
        self.status = status
        self.data = data
    }
    
    var data: Data {
        get {
            do {
                return try Data(format: format, value: value)
            } catch let error {
                fatalError("Failed to get content item data: \(error)")
            }
        }
        set {
            format = newValue.format
            value = newValue.value
        }
    }
    
    var status: Status {
        get {
            do {
                return try Status(value: _status)
            } catch let error {
                fatalError("Failed to get content item status: \(error)")
            }
        }
        set {
            _status = newValue.value
        }
    }
    
    var secondsRequired: Int {
        // FIXME: Mock Implementation
        switch data {
        case .text:
            return 60
        case .video:
            return 300
        }
    }
}

fileprivate extension ContentItem.Data {
    enum Error: Swift.Error {
        case invalid(format: String, value: String)
    }
    
    struct Key {
        static let text = "text"
        static let video = "video"
    }
    
    init(format: String, value: String) throws {
        switch format {
        case Key.text:
            self = .text(value)
        case Key.video:
            guard let url = URL(string: value) else { throw Error.invalid(format: format, value: value) }
            self = .video(url)
        default:
            throw Error.invalid(format: format, value: value)
        }
    }
    
    var format: String {
        switch self {
        case .text: return Key.text
        case .video: return Key.video
        }
    }
    
    var value: String {
        switch self {
        case .text(let value): return value
        case .video(let url): return url.absoluteString
        }
    }
}

fileprivate extension ContentItem.Status {
    enum Error: Swift.Error {
        case invalid(value: String)
    }
    
    struct Key {
        static let viewed = "viewed"
        static let notViewed = "notViewed"
    }
    
    init(value: String) throws {
        switch value {
        case Key.viewed:
            self = .viewed
        case Key.notViewed:
            self = .notViewed
        default:
            throw Error.invalid(value: value)
        }
    }
    
    var value: String {
        switch self {
        case .viewed: return Key.viewed
        case .notViewed: return Key.notViewed
        }
    }
}
