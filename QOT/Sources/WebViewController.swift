//
//  WebViewController.swift
//  QOT
//
//  Created by karmic on 06.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import SafariServices
import Foundation
import qot_dal

final class WebViewController: SFSafariViewController {

    init(_ url: URL) throws {
        guard url.canOpen else {
            throw SimpleError(localizedDescription: "Unsupported URL scheme for: \(url)")
        }
        if #available(iOS 11.0, *) {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = false
            configuration.barCollapsingEnabled = false
            super.init(url: url, configuration: configuration)
        } else {
            super.init(url: url, entersReaderIfAvailable: false)
        }
    }
}

extension WebViewController {
    override public func viewWillAppear(_ animated: Bool) {
        // Make sure that stop playing Audio
        NotificationCenter.default.post(name: .stopAudio, object: nil)
        super.viewWillAppear(animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshBottomNavigationItems()
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

// MARK: - URL

private extension URL {

    var canOpen: Bool {
        guard let scheme = scheme else { return false }
        return scheme.caseInsensitiveCompare("http") == .orderedSame || scheme.caseInsensitiveCompare("https") == .orderedSame
    }
}
