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

    case text(text: String, style: ContentItemTextStyle)
    case video(title: String, description: String?, placeholderURL: URL, videoURL: URL, duration: TimeInterval)
    case audio(title: String, description: String?, placeholderURL: URL, audioURL: URL, duration: TimeInterval, waveformData: [Float])
    case image(title: String, description: String?, url: URL)

    init(format: ContentItemFormat, value: String) throws {
        let json = try JSON(jsonString: value)
        switch format {
        case .textH1,
             .textH2,
             .textH3,
             .textH4,
             .textH5,
             .textH6,
             .textParagraph,
             .textBullet:
            let text = try json.getString(at: "text")
            guard let style = ContentItemTextStyle.createStyle(for: format) else {
                throw ContentItemTextStyleError.noValidItemTextStyleError
            }
            
            self = .text(text: text, style: style)

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
        }
    }
}

// FIXME: Unit test

enum ContentItemTextStyleError: String, Error {
    case noValidItemTextStyleError = "Could not find a valid item text style."
}

enum ContentItemTextStyle: String {
    case h1 = "text.h1"
    case h2 = "text.h2"
    case h3 = "text.h3"
    case h4 = "text.h4"
    case h5 = "text.h5"
    case h6 = "text.h6"
    case bullet = "text.bullet"
    case paragraph = "text.paragraph"

    static func createStyle(for format: ContentItemFormat) -> ContentItemTextStyle? {
        return ContentItemTextStyle(rawValue: format.rawValue)
    }
}

enum ContentItemFormat: String {
    case textH1 = "text.h1"
    case textH2 = "text.h2"
    case textH3 = "text.h3"
    case textH4 = "text.h4"
    case textH5 = "text.h5"
    case textH6 = "text.h6"
    case textParagraph = "text.paragraph"
    case textBullet = "text.bullet"
    case video
    case audio
    case image

    static var allValues: [ContentItemFormat] {
        return [
            .textH1,
            .textH2,
            .textH3,
            .textH4,
            .textH5,
            .textH6,
            .textParagraph,
            .textBullet,
            .video,
            .audio,
            .image
        ]
    }

    static var randomItemFormat: ContentItemFormat {
        let randomIndex = Int.random(between: 0, and: ContentItemFormat.allValues.count)
        return ContentItemFormat.allValues[randomIndex]
    }
}
