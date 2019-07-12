//
//  NSPredicate+Convenience.swift
//  Pods
//
//  Created by Sam Wyndham on 11/05/2017.
//
//

import Foundation

extension NSPredicate {

    static var newWhatsHotArticles: NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [section(.learnWhatsHot), unReadArticles])
    }

    static var unReadArticles: NSPredicate {
        if let date = UserDefault.firstInstallationTimestamp.object as? NSDate {
            return NSPredicate(format: "contentRead == nil AND publishDate > %@", date)
        }
        return NSPredicate(format: "contentRead == nil")
    }

    static func slideShow() -> NSPredicate {
        return NSPredicate(format: "section CONTAINS %@", Database.Section.slideShow.rawValue)
    }

    static func section(_ section: Database.Section) -> NSPredicate {
        return NSPredicate(section: section.value)
    }

    static func preparationID(_ id: String) -> NSPredicate {
        return NSPredicate(format: "preparation.localID == %@", id)
    }

    static func key(_ key: String) -> NSPredicate {
        return NSPredicate(format: "key == %@", key)
    }

    static func deleted(_ deleted: Bool) -> NSPredicate {
        return NSPredicate(format: "deleted == %@", NSNumber(value: deleted))
    }

    static func questionGroupIDis(_ id: Int) -> NSPredicate {
        return NSPredicate(format: "questionGroupID == %d", id)
    }

    convenience init(remoteID: Int) {
        self.init(format: "remoteID == %d", remoteID)
    }

    convenience init(section: String) {
        self.init(format: "section == %@", section)
    }

    convenience init(section: String, title: String) {
        self.init(format: "section == %@ AND title == %@", section, title)
    }

    convenience init(remoteIDs: [Int]) {
        self.init(format: "remoteID IN %@", remoteIDs)
    }

    convenience init(dirty: Bool) {
        self.init(format: "dirty == %@", NSNumber(value: dirty))
    }

    convenience init(eventIDs: [String]) {
        self.init(format: "eventID IN %@", eventIDs)
    }

    convenience init(groupContains word: String) {
        self.init(format: "group CONTAINS %@", word)
    }

    convenience init(title: String, startDate: Date, endDate: Date) {
        self.init(format: "title == %@ AND startDate == %@ AND endDate == %@", startDate as NSDate, endDate as NSDate)
    }

    convenience init(tag: String) {
        self.init(format: "searchTags == %@", tag)
    }

    convenience init(dalSearchTag: String) {
        self.init(format: "ANY searchTagsDetailed.name contains[c] %@", dalSearchTag)
    }

    convenience init(searchTag: String) {
        self.init(format: "searchTags contains[c] %@", searchTag)
    }

    convenience init(title: String) {
        self.init(format: "title == %@", title)
    }

    convenience init(localID: String) {
        self.init(format: "localID == %@", localID)
    }
}
