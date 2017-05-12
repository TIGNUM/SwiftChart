//
//  ContentItemValue.swift
//  Pods
//
//  Created by Sam Wyndham on 11/04/2017.
//
//

import Foundation
import Freddy

// FIXME: Unit test
enum ContentItemValue {

    case text(String)
    case video(title: String, description: String?, placeholderURL: URL, videoURL: URL, duration: TimeInterval)
    case audio(title: String, description: String?, placeholderURL: URL, audioURL: URL, duration: TimeInterval, waveformData: [Float])
    case image(title: String, description: String?, url: URL)
    case bullet(String)

    init(format: ContentItemFormat, value: String) throws {
        let json = try JSON(jsonString: value)

        switch format {
        case .text:
            let text = try json.getString(at: "text")
            self = .text(text)
        case .video:
            let title = try json.getString(at: "title")
            let description = try json.getString(at: "description", alongPath: .NullBecomesNil)
            let placeholderURL = try json.decode(at: "placeholderURL", type: URL.self)
            let videoURL = try json.decode(at: "videoURL", type: URL.self)
            let duration = TimeInterval(try json.getInt(at: "duration"))

            self = .video(title: title, description: description, placeholderURL: placeholderURL, videoURL: videoURL, duration: duration)
        case .audio:
            let title = try json.getString(at: "title")
            let description = try json.getString(at: "description", alongPath: .NullBecomesNil)
            let placeholderURL = try json.decode(at: "placeholderURL", type: URL.self)
            let audioURL = try json.decode(at: "audioURL", type: URL.self)
            let duration = TimeInterval(try json.getInt(at: "duration"))
            let waveformData = try json.getArray(at: "waveformData").map { try Double(json: $0) }.map { Float($0) }

            self = .audio(title: title, description: description, placeholderURL: placeholderURL, audioURL: audioURL, duration: duration, waveformData: waveformData)
        case .image:
            let title = try json.getString(at: "title")
            let description = try json.getString(at: "description", alongPath: .NullBecomesNil)
            let url = try json.decode(at: "url", type: URL.self)

            self = .image(title: title, description: description, url: url)
        case .bullet:
            let text = try json.getString(at: "text")
            self = .bullet(text)
        }
    }
}

// FIXME: Unit test
enum ContentItemFormat: Int8 {
    case text = 0
    case video = 1
    case audio = 2
    case image = 3
    case bullet = 4
}
