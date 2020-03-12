//
//  ShareExtensionViewController.swift
//  ShareExtension
//
//  Created by Sanggeon Park on 07.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareExtensionViewController: SLComposeServiceViewController {
    private var shareExtensionData = ShareExtentionData()
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            self.imageView.isHidden = false
        }
        self.shareExtensionData.date = Date()
        ExtensionUserDefaults.set(self.shareExtensionData, for: .saveLink, in: .share)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            if let context = self.extensionContext {
                context.completeRequest(returningItems: [], completionHandler: nil)
            } else {
                super.didSelectPost()
            }
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        view.subviews.forEach {
            if $0.tag != 2020 {
                $0.removeFromSuperview()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "QOT"

        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        guard let itemProvider = extensionItem.attachments?.first else {
            handleFailure()
            return
        }
        let typeURL = String(kUTTypeURL)
        let textTypes = [String(kUTTypeText),
                         String(kUTTypePlainText),
                         String(kUTTypeUTF8PlainText),
                         String(kUTTypeUTF16PlainText)]
        if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { [weak self] (item, error) -> Void in
                guard let strongSelf = self, let url = item as? URL else {
                    self?.handleFailure()
                    return
                }
                strongSelf.handleURL(url)
            }
        } else {
            for type in textTypes where itemProvider.hasItemConformingToTypeIdentifier(type) {
                itemProvider.loadItem(forTypeIdentifier: type, options: nil) { [weak self] (item, error) -> Void in
                    guard let strongSelf = self, let string = item as? String else {
                        self?.handleFailure()
                        return
                    }
                    strongSelf.handleString(string)
                }
                break
            }
        }
    }

    func urls(from string: String) -> [URL]? {
        do {
            let pattern = "^(http:\\/\\/www\\.|https:\\/\\/www\\.|http:\\/\\/|https:\\/\\/)?[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,5}(:[0-9]{1,5})?(\\/.*)?$"
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                .compactMap {
                    return URL(string: String(string[Range($0.range, in: string)!]))
            }
            return results
        } catch {
            return nil
        }
    }

    func handleString(_ string: String) {
        if let url = URL(string: string) {
            handleURL(url)
        } else if let urls = urls(from: string), urls.count == 1, let url = urls.first {
            handleURL(url)
        } else {
            addNote(string)
        }
    }

    func handleURL(_ url: URL) {
        shareExtensionData.type = "EXTERNAL_LINK"
        shareExtensionData.url = url.absoluteString
        didSelectPost()
    }

    func addNote(_ string: String) {
        shareExtensionData.type = "NOTE"
        shareExtensionData.description = string
        didSelectPost()
    }

    func handleFailure() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            self.imageView.image = UIImage(named: "CrossImage")
            self.imageView.isHidden = false
            self.cancel()
        }
    }
}
