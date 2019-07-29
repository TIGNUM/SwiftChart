//
//  EKEvent+Convenience.swift
//  QOT
//
//  Created by karmic on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit

protocol EKEventEditable {
    func addPreparationLink(preparationID: String?, permissionsManager: PermissionsManager)
}

extension EKEvent: EKEventEditable {
    func addPreparationLink(preparationID: String?, permissionsManager: PermissionsManager) {
        guard let localID = preparationID else { return }
        permissionsManager.askPermission(for: [.calendar], completion: { [weak self] status in
            guard let status = status[.calendar], let strongSelf = self else { return }
            switch status {
            case .granted:
                var tempNotes = strongSelf.notes ?? ""
                guard let preparationLink = URLScheme.preparationURL(withID: localID) else { return }
                tempNotes += "\n\n" + preparationLink
                log("preparationLink: \(preparationLink)")
                strongSelf.notes = tempNotes
                do {
                    try EKEventStore.shared.save(strongSelf, span: .thisEvent, commit: true)
                } catch let error {
                    log("createPreparation - eventStore.save.error: \(error.localizedDescription)", level: .error)
                    return
                }
            case .later:
                permissionsManager.updateAskStatus(.canAsk, for: .calendar)
            default:
                break
            }
        })
    }

    func addPreparationLink(preparationID: String?) {
        guard let localID = preparationID else { return }
        var tempNotes = notes ?? ""
        guard let preparationLink = URLScheme.preparationURL(withID: localID) else { return }
        tempNotes += "\n\n" + preparationLink
        log("preparationLink: \(preparationLink)")
        notes = tempNotes
        do {
            try EKEventStore.shared.save(self, span: .thisEvent, commit: true)
        } catch let error {
            log("createPreparation - eventStore.save.error: \(error.localizedDescription)", level: .error)
            return
        }
    }

    func removePreparationLink() throws {
        guard let currentNotes = self.notes, self.hasNotes == true else { return }
        let regex = try NSRegularExpression(pattern: "(qotapp:\\/\\/preparation#[A-Z0-9-]+)", options: [])
        guard let regexMatch = regex.matches(in: currentNotes,
                                             options: [],
                                             range: NSRange(location: 0, length: currentNotes.count)).first else {
            return
        }
        // FIXME: swift 4 has ability to convert NSRange -> Range, so we can then use string.removeSubrange()
        // @see https://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
        self.notes = (currentNotes as NSString).replacingCharacters(in: regexMatch.range, with: "")
    }
}
