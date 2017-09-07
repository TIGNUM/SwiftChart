//
//  SFSafariViewController+Convenience.swift
//  QOT
//
//  Created by karmic on 06.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import SafariServices
import Foundation

final class SafariViewController: SFSafariViewController {

    convenience init(_ url: URL) throws {
        guard SafariViewController.canOpenURL(url) else {
            throw SimpleError(localizedDescription: "Unsupported URL scheme for: \(url)")
        }
        self.init(url: url)
    }

    static func canOpenURL(_ url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }

        return scheme.caseInsensitiveCompare("http") == .orderedSame || scheme.caseInsensitiveCompare("https") == .orderedSame
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        UIApplication.shared.statusBarStyle = .default
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
