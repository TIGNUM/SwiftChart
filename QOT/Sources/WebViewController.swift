//
//  WebViewController.swift
//  QOT
//
//  Created by karmic on 06.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import SafariServices
import Foundation

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

// MARK: - URL

private extension URL {

    var canOpen: Bool {
        guard let scheme = scheme else { return false }
        return scheme.caseInsensitiveCompare("http") == .orderedSame || scheme.caseInsensitiveCompare("https") == .orderedSame
    }
}
