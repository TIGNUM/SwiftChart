//
//  MyToBeVision.swift
//  QOT
//
//  Created by Lee Arromba on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

enum MyToBeVisionKeywordType: String {
    case work
    case home
}

final class MyToBeVision: SyncableObject {

    @objc dynamic var profileImageResource: MediaResource? = MediaResource()

    @objc dynamic var headline: String?

    @objc dynamic var subHeadline: String?

    @objc dynamic var text: String?

    @objc dynamic var date: Date?

    @objc dynamic var changeStamp: String?

    @objc dynamic var needsToRemind = false

    @objc private dynamic var keywordsWork: String?

    @objc private dynamic var keywordsHome: String?

    convenience init(headline: String?, text: String?) {
        self.init()
        self.headline = headline
        self.text = text
    }
}

extension MyToBeVision: TwoWaySyncableUniqueObject {

    func setKeywords(_ tags: [String], for type: MyToBeVisionKeywordType) {
        switch type {
        case .home:
            keywordsHome = tags.joined(separator: ";")
        case .work:
            keywordsWork = tags.joined(separator: ";")
        }
    }

    func keywords(for type: MyToBeVisionKeywordType) -> [String] {
        switch type {
        case .home:
            return keywordsHome?.components(separatedBy: ";") ?? []
        case .work:
            return keywordsWork?.components(separatedBy: ";") ?? []
        }
    }

    func setData(_ data: MyToBeVisionIntermediary, objectStore: ObjectStore) throws {
        if let date = date, date > data.validFrom {
            /*
             FIXME: HACK!!!! API accepts a dictionary of MyToBeVision properties for upload but returns an array of all
             previous my to be visions on download rather than the most recent version. So we will only set the data if
             the data is later then the current data. DISCUSS WITH BACKEND
             */
            return
        }

        headline = data.headline
        subHeadline = data.subHeadline
        text = data.text
        date = data.validFrom
        profileImageResource?.setRemoteURL(data.remoteProfileImageURL.flatMap({ URL(string: $0) }))
        setKeywords(data.workTags, for: .work)
        setKeywords(data.homeTags, for: .home)
    }

    static func object(remoteID: Int, store: ObjectStore, data: MyToBeVisionIntermediary) throws -> MyToBeVision? {
        let object = store.objects(MyToBeVision.self).first
        object?.setRemoteIDValue(remoteID)
        return object
    }

    static var endpoint: Endpoint {
        return .myToBeVision
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean, let date = date else { return nil }
        let workTags: [JsonKey: JSONEncodable] = [.key: JsonKey.work.rawValue, .tags: self.keywords(for: .work).toJSON()]
        let homeTags: [JsonKey: JSONEncodable] = [.key: JsonKey.home.rawValue, .tags: self.keywords(for: .home).toJSON()]
        let keywordTags: [JSON] = [.dictionary(workTags.mapKeyValues({ ($0.rawValue, $1.toJSON()) })),
                                   .dictionary(homeTags.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))]
        let dict: [JsonKey: JSONEncodable] = [
            .syncStatus: syncStatus.rawValue,
            .title: headline.toJSONEncodable,
            .shortDescription: subHeadline.toJSONEncodable,
            .description: text.toJSONEncodable,
            .validFrom: date,
            .keywordTags: keywordTags.toJSON()
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension MyToBeVision {

    var model: MyToBeVisionModel.Model {
        return MyToBeVisionModel.Model(headLine: headline,
                                       imageURL: profileImageResource?.localURL ?? profileImageResource?.remoteURL,
                                       lastUpdated: date,
                                       text: text,
                                       needsToRemind: needsToRemind,
                                       workTags: nil,
                                       homeTags: nil)
    }
}
