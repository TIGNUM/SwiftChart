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
    case listItem(text: String)
    case video(title: String, description: String?, placeholderURL: URL, videoURL: URL, duration: TimeInterval)
    case audio(title: String, description: String?, placeholderURL: URL, audioURL: URL, duration: TimeInterval, waveformData: [Float])
    case image(title: String, description: String?, url: URL)
    case invalid

    init(item: ContentItem) {
        guard let format = ContentItemFormat(rawValue: item.format) else {
            self = .invalid
            return
        }

        let mediaURL = item.valueMediaURL.flatMap { URL(string: $0) }
        let imageURL = item.valueImageURL.flatMap { URL(string: $0) }
        let duration = item.valueDuration.value.map { TimeInterval($0) }

        switch format {
        case .textH1,
             .textH2,
             .textH3,
             .textH4,
             .textH5,
             .textH6,
             .textParagraph,
             .textQuote:
            if let text = item.valueText, let style = ContentItemTextStyle.createStyle(for: format) {
                self = .text(text: text, style: style)
            } else {
                self = .invalid
            }
        case .listItem:
            if let text = item.valueText {
                self = .listItem(text: text)
            } else {
                self = .invalid
            }
        case .video:
            if let title = item.valueText, let placeholder = imageURL, let video = mediaURL, let duration = duration {
                self = .video(title: title, description: item.valueDescription, placeholderURL: placeholder, videoURL: video, duration: duration)
            } else {
                self = .invalid
            }
        case .audio:
            if let title = item.valueText, let placeholder = imageURL, let audio = mediaURL, let duration = duration, let waveform = item.waveformData {
                self = .audio(title: title, description: item.valueDescription, placeholderURL: placeholder, audioURL: audio, duration: duration, waveformData: waveform)
            } else {
                self = .invalid
            }
        case .image:
            if let title = item.valueText, let url = imageURL {
                self = .image(title: title, description: item.valueDescription, url: url)
            } else {
                self = .invalid
            }
        }
    }

    // FIXME: Remove once not needed for mocks
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
             .textQuote:
            let text = try json.getString(at: "text")

            guard let style = ContentItemTextStyle.createStyle(for: format) else {
                throw ContentItemTextStyleError.noValidItemTextStyleError
            }

            self = .text(text: text, style: style)

        case .listItem:
            self = .listItem(text: try json.getString(at: "text"))
        case .video:
            let title = try json.getString(at: "title")
            let description = try json.getString(at: "description", alongPath: .NullBecomesNil)
            let placeholderURL = try json.decode(at: "thumbnailURL", type: URL.self)
            let videoURL = try json.decode(at: "videoURL", type: URL.self)
            let duration = TimeInterval(try json.getInt(at: "duration"))
            self = .video(title: title, description: description, placeholderURL: placeholderURL, videoURL: videoURL, duration: duration)
        case .audio:
            let title = try json.getString(at: "title")
            let description = try json.getString(at: "description", alongPath: .NullBecomesNil)
            let placeholderURL = try json.decode(at: "thumbnailURL", type: URL.self)
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

    func style(textStyle: ContentItemTextStyle, text: String, textColor: UIColor) -> NSAttributedString {
        switch textStyle {
        case .h1: return Style.postTitle(text, textColor).attributedString()
        case .h2: return Style.secondaryTitle(text, textColor).attributedString()
        case .h3: return Style.subTitle(text, textColor).attributedString()
        case .h4: return Style.headline(text, textColor).attributedString()
        case .h5: return Style.headlineSmall(text, textColor).attributedString()
        case .h6: return Style.navigationTitle(text, textColor).attributedString()
        case .paragraph: return Style.paragraph(text, textColor).attributedString()
        case .quote: return Style.tag(text, textColor).attributedString()
        }
    }
}

private extension ContentItem {

    var waveformData: [Float]? {
        return valueWavformData.flatMap { (jsonString) -> [Float]? in
            do {
                if let json = try? JSON(jsonString: jsonString) {
                    let jsons = try json.getArray()
                    let doubles = try jsons.map { try Double(json: $0) }
                    return doubles.map { Float($0) }
                } else {
                    return nil
                }
            } catch {
                return nil
            }
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
    case paragraph = "text.paragraph"
    case quote = "text.quote"    

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
    case textQuote = "text.quote"
    case listItem = "listitem"
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
            .textQuote,
            .listItem,
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
