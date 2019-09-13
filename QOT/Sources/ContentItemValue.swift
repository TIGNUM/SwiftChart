//
//  ContentItemValue.swift
//  Pods
//
//  Created by Sam Wyndham on 11/04/2017.
//
//

import Foundation
import qot_dal

// FIXME: Unit test
enum ContentItemValue {

    case articleNextUp(title: String, description: String, itemID: Int)
    case articleRelatedWhatsHot(relatedArticle: Article.RelatedArticleWhatsHot)
    case articleRelatedStrategy(title: String, description: String, itemID: Int)
    case headerText(header: Article.Header)
    case headerImage(imageURLString: String?)
    case text(text: String, style: ContentItemTextStyle)
    case listItem(text: String)
    case video(remoteId: Int, title: String, description: String?, placeholderURL: URL?, videoURL: URL, duration: TimeInterval)
    case audio(remoteId: Int, title: String, description: String?, placeholderURL: URL?, audioURL: URL, duration: TimeInterval, waveformData: [Float])
    case image(title: String, description: String?, url: URL)
    case prepareStep(title: String, description: String, relatedContentID: Int?)
    case pdf(title: String, description: String?, pdfURL: URL, itemID: Int)
    case button(selected: Bool)
    case guide
    case guideButton
    case invalid

    init(item: QDMContentItem) {

        let text = item.valueText.isEmpty ? nil : item.valueText.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = item.valueDescription.isEmpty ? nil : item.valueDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let localMediaPath = item.userStorages?.filter({ (storage) -> Bool in
            storage.userStorageType == .DOWNLOAD
        }).first?.mediaPath() ?? ""

        let mediaURL = URL(string: localMediaPath) ?? item.valueMediaURL.flatMap { URL(string: $0) }
        let imageURL = item.valueImageURL.flatMap { URL(string: $0) }
        let duration = item.valueDuration ?? 0
        let itemID = item.remoteID ?? 0

        switch item.format {
        case .header1,
             .header2,
             .header3,
             .header4,
             .header5,
             .header6,
             .paragraph,
             .body,
             .textQuote:
            if let text = text, let style = ContentItemTextStyle.createStyle(for: item.format.rawValue) {
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
        case .listitem:
            if let text = text {
                self = .listItem(text: text)
            } else {
                self = .invalid
            }
        case .video:
            if let title = text, let video = mediaURL {
                self = .video(remoteId: item.remoteID ?? 0, title: title, description: description, placeholderURL: imageURL, videoURL: video, duration: duration)
            } else {
                self = .invalid
            }
        case .audio:
            if let audio = mediaURL {
                let title = text ?? ""
                self = .audio(remoteId: item.remoteID ?? 0, title: title, description: description, placeholderURL: audio, audioURL: audio, duration: duration, waveformData: [])
            } else {
                self = .invalid
            }
        case .image:
            if let title = text, let url = imageURL {
                self = .image(title: title, description: description, url: url)
            } else {
                self = .invalid
            }
        case .prepare:
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
        default: self = .invalid
        }
    }

    func theme(textStyle: ContentItemTextStyle) -> ThemeText {
        switch textStyle {
        case .h1: return .articlePostTitle
        case .h2: return .articleSecondaryTitle
        case .h3: return .articleSubTitle
        case .h4: return .articleHeadline
        case .h5: return .articleHeadlineSmall
        case .h6: return .articleNavigationTitle
        case .body: return .articleParagraph
        case .paragraph: return .articleParagraph
        case .quote: return .articleQuote
        }
    }

    var duration: Int {
        switch self {
        case .audio(_, _, _, _, _, let duration, _): return duration.toInt
        default: return 0
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
    case body
    case paragraph = "text.paragraph"
    case quote = "text.quote"

    static func createStyle(for format: ContentItemFormat) -> ContentItemTextStyle? {
        return ContentItemTextStyle(rawValue: format.rawValue)
    }

    static func createStyle(for rawValue: String) -> ContentItemTextStyle? {
        return ContentItemTextStyle(rawValue: rawValue)
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
    case body
    case textParagraph = "text.paragraph"
    case textQuote = "text.quote"
    case listItem = "listitem"
    case list
    case title
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
