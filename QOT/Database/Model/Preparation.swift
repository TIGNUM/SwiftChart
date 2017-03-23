///
//  Preparation.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

// FIXME: Unit test once data model is finalized.
class Preparation: Object {

    enum ChatType {
        case instructions(messages: [String])
        case preparations(messages: [String])
        case dayProtocols(messages: [String])
    }

    enum Status {
        case displaying
        case received
    }

    // MARK: - Properties

    dynamic var id: Int = 0
    dynamic var sort: Int = 0
    dynamic var name: String = ""
    dynamic var title: String = ""

    private dynamic var type: String = ""
    private dynamic var messages: [String] = []

    override class func primaryKey() -> String? {
        return Databsase.Key.primary.rawValue
    }

    // MARK: - Life Cycle

    // FIXME: Unit test once data model is finalized.
    convenience init(id: Int, sort: Int, name: String, title: String, chatType: Preparation.ChatType) {
        self.init()
        self.id = id
        self.sort = sort
        self.name = name
        self.title = title
        self.chatType = chatType
    }

    var chatType: ChatType {
        get {
            do {
                return try ChatType(type: type, messages: messages)
            } catch let error {
                fatalError("Failed to get content item status: \(error)")
            }
        }
        set {
            messages = newValue.messages
        }
    }
}

fileprivate extension Preparation.ChatType {
    enum Error: Swift.Error {
        case invalid(type: String, messages: [String])
    }

    struct Key {
        static let instruction = "instruction"
        static let preparation = "preparation"
        static let dayProtocol = "dayProtocol"
    }

    init(type: String, messages: [String]) throws {
        switch type {
        case Key.instruction: self = .instructions(messages: messages)
        case Key.preparation: self = .preparations(messages: messages)
        case Key.dayProtocol: self = .dayProtocols(messages: messages)
        default: throw Error.invalid(type: type, messages: messages)
        }
    }

    var messages: [String] {
        switch self {
        case .instructions(let messages): return messages
        case .preparations(let messages): return messages
        case .dayProtocols(let messages): return messages
        }
    }
}

fileprivate extension Preparation.Status {
    enum Error: Swift.Error {
        case invalid(value: String)
    }

    struct Key {
        static let displaying = "displaying"
        static let received = "received"
    }

    init(value: String) throws {
        switch value {
        case Key.displaying: self = .displaying
        case Key.received: self = .received
        default: throw Error.invalid(value: value)
        }
    }

    var value: String {
        switch self {
        case .displaying: return Key.displaying
        case .received: return Key.received
        }
    }
}
