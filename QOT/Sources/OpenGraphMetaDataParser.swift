//
//  OpenGraphMetaDataParser.swift
//  QOT
//
//  Created by Sanggeon Park on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

typealias MetaDataResult = (OpenGraphMetaData?, Error?) -> Void

struct OpenGraphMetaData {
    enum property: String {
        case title = "og:title"
        case image = "og:image"
        case url = "og:url"
        case description = "og:description"
        case locale = "og:locale"
        case type = "og:type"
    }

    private let metaDataDictionary: [String: String]

    init(_ meta: [String: String]) {
        metaDataDictionary = meta
    }

    func content(for property: OpenGraphMetaData.property) -> String? {
        return content(for: property.rawValue)
    }

    func content(for property: String) -> String? {
        return metaDataDictionary[property]
    }
}

final class OpenGraphMetaDataParser: NSObject, XMLParserDelegate {
    private var url: URL?
    private var completion: MetaDataResult?
    private var dictionary = [String: String]()
    private var currentElement = ""
    private var imageURL: String?
    private var title: String?

    init(with url: URL?) {
        self.url = url
    }

    func parseMeta(_ completion: @escaping MetaDataResult) {
        self.completion = completion
        guard let url = self.url else {
            self.completion?(nil, nil)
            self.completion = nil
            return
        }
        dictionary.removeAll()
        currentElement = ""
        imageURL = nil
        title = nil
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let string = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .ascii) ?? ""
                let regex = try NSRegularExpression(pattern: "<meta.*>|<title.*.title>|<link.*>")
                _ = regex.matches(in: string, range: NSRange(string.startIndex..., in: string)).compactMap {
                    let metaString = String(string[Range($0.range, in: string)!])
                    let xmlParser = XMLParser(data: metaString.data(using: .utf8) ?? Data())
                    xmlParser.delegate = self
                    xmlParser.parse()
                }

                DispatchQueue.main.async {
                    if self.dictionary[OpenGraphMetaData.property.image.rawValue] == nil,
                        let imageURL = self.imageURL {
                        self.dictionary[OpenGraphMetaData.property.image.rawValue] = imageURL
                    }
                    if self.dictionary[OpenGraphMetaData.property.title.rawValue] == nil,
                        let title = self.title {
                        self.dictionary[OpenGraphMetaData.property.title.rawValue] = title
                    }
                    self.completion?(OpenGraphMetaData(self.dictionary), nil)
                    self.completion = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.completion?(nil, error)
                    self.completion = nil
                }
            }
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if elementName == "meta", let poperty = attributeDict["property"] {
            dictionary[poperty] = attributeDict["content"]
        } else if self.imageURL == nil, elementName == "link",
            let rel = attributeDict["rel"], rel.lowercased().contains("icon"),
            let href = attributeDict["href"] {
            let scheme = self.url?.scheme ?? "http"
            if href.hasPrefix(scheme) {
                self.imageURL = href
            } else {
                self.imageURL = "\(scheme)://\(self.url?.host ?? "")\(href)"
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement.lowercased() == "title" {
            title = (title ?? "") + string
        }
    }
}
