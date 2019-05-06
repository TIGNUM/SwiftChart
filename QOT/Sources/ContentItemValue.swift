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

    case articleRelatedWhatsHot(relatedArticle: Article.RelatedArticle)
    case articleRelatedStrategy(relatedArticle: Article.RelatedArticle)
    case headerText(header: Article.Header)
    case headerImage(imageURLString: String?)
    case text(text: String, style: ContentItemTextStyle)
    case listItem(text: String)
    case video(title: String, description: String?, placeholderURL: URL?, videoURL: URL, duration: TimeInterval)
    case audio(title: String, description: String?, placeholderURL: URL?, audioURL: URL, duration: TimeInterval, waveformData: [Float])
    case image(title: String, description: String?, url: URL)
    case prepareStep(title: String, description: String, relatedContentID: Int?)
    case pdf(title: String, description: String?, pdfURL: URL, itemID: Int)
    case button(selected: Bool)
    case guide
    case guideButton
    case invalid

    init(item: ContentItem) {
        guard let format = ContentItemFormat(rawValue: item.format) else {
            self = .invalid
            return
        }

        let text = item.valueText?.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = item.valueDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mediaURL = item.bundledAudioURL ?? item.valueMediaURL.flatMap { URL(string: $0) }
        let imageURL = item.valueImageURL.flatMap { URL(string: $0) }
        let duration = item.valueDuration.value.map { TimeInterval($0) }
        let itemID = item.forcedRemoteID

        switch format {
        case .textH1,
             .textH2,
             .textH3,
             .textH4,
             .textH5,
             .textH6,
             .textParagraph,
             .textQuote:
            if let text = text, let style = ContentItemTextStyle.createStyle(for: format) {
                self = .text(text: text, style: style)
            } else {
                self = .invalid
            }
        case .guideTitle,
             .guideType,
             .guideBody:
            self = .guide
        case .guideFeatureButton:
            self = .guideButton
        case .listItem:
            if let text = text {
                self = .listItem(text: text)
            } else {
                self = .invalid
            }
        case .video:
            if let title = text, let video = mediaURL, let duration = duration {
                self = .video(title: title, description: description, placeholderURL: imageURL, videoURL: video, duration: duration)
            } else {
                self = .invalid
            }
        case .audio:
            if let title = text, let audio = mediaURL, let duration = duration, let waveform = item.waveformData {
                self = .audio(title: title, description: description, placeholderURL: audio, audioURL: audio, duration: duration, waveformData: waveform)
            } else {
                self = .invalid
            }
        case .image:
            if let title = text, let url = imageURL {
                self = .image(title: title, description: description, url: url)
            } else {
                self = .invalid
            }
        case .preparationStep:
            if let title = text, let description = description {
                self = .prepareStep(title: title, description: description, relatedContentID: item.relatedContent.first?.contentID)
            } else {
                self = .invalid
            }
        case .pdf:
            if let title = text, let description = description, let pdf = mediaURL {
                self = .pdf(title: title, description: description, pdfURL: pdf, itemID: itemID)
            } else {
                self = .invalid
            }
        }
    }

    func style(textStyle: ContentItemTextStyle, text: String, textColor: UIColor, lineSpacing: CGFloat = 1, lineHeight: CGFloat = 1) -> NSAttributedString {
        switch textStyle {
        case .h1: return Style.postTitle(text, textColor).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .h2: return Style.secondaryTitle(text, textColor).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .h3: return Style.subTitle(text, textColor).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .h4: return Style.headline(text, textColor).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .h5: return Style.headlineSmall(text, textColor).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .h6: return Style.navigationTitle(text, textColor).attributedString(lineSpacing: 2, lineHeight: lineHeight)
        case .paragraph: return Style.paragraph(text, textColor).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        case .quote: return Style.qoute(text, .white60).attributedString(lineSpacing: lineSpacing, lineHeight: lineHeight)
        }
    }

    var duration: Int {
        switch self {
        case .audio(_, _, _, _, let duration, _): return duration.toInt
        default: return 0
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

    var headline: Bool {
        switch self {
        case .h1, .h2, .h3, .h4, .h5, .h6: return true
        default: return false
        }
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
    case preparationStep = "prepare"
    case pdf
    case guideTitle = "guide.title"
    case guideType = "guide.type"
    case guideBody = "guide.body"
    case guideFeatureButton = "guide.feature.button"
}
