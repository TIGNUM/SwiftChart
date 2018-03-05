//
//  ShareWorker.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class ShareWorker {

    enum Error: Swift.Error {
        case missingHTMLFile

    }

    let services: Services
    let partnerName: String
    let partnerEmail: String

    init(services: Services, partnerName: String, partnerEmail: String) {
        self.services = services
        self.partnerName = partnerName
        self.partnerEmail = partnerEmail
    }

    func shareToBeVisionEmailContent() throws -> Share.EmailContent {
        return Share.EmailContent(email: partnerEmail, subject: "Hello", body: try html(fileName: "to_be_vision"))
    }

    func shareWeeklyChoicesEmailContent() throws -> Share.EmailContent {
        return Share.EmailContent(email: partnerEmail, subject: "Hello", body: try html(fileName: "weekly_choices"))
    }

    private func html(fileName: String) throws -> String {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "html") else {
            throw SimpleError(localizedDescription: "Failed to fetch HTML for resource \(fileName)")
        }

        var content = try String(contentsOf: url)
        content = content.replacingOccurrences(of: "*|PARTNER:FIRSTNAME|*", with: partnerName)
        if let toBeVision = services.userService.myToBeVision()?.text {
            content = content.replacingOccurrences(of: "*|MTBV|*", with: toBeVision)
        }
        if let user = services.userService.user() {
            let fullName = "\(user.givenName) \(user.familyName)"
            content = content.replacingOccurrences(of: "*|FULL USER NAME|*", with: fullName)
            content = content.replacingOccurrences(of: "*|USERNAME|*", with: user.givenName)
        }

        return content
    }

}
