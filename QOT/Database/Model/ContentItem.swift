//
//  ContentItem.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ContentItem: Object {
    enum Data {
        case text(String)
        case video(URL)
    }
    
    private dynamic var value: String = ""
    private dynamic var format: String = ""
    
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var status: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, title: String, status: Int, data: ContentItem.Data) {
        self.init()
        self.id = id
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
