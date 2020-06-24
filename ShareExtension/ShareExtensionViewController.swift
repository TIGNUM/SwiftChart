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

// NOT USED ANYMORE

class ShareExtensionViewController: SLComposeServiceViewController {
    private var shareExtensionData = ShareExtentionData()
//    @IBOutlet private weak var imageView: UIImageView!
//    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
//        DispatchQueue.main.async {
//            self.loadingIndicator.stopAnimating()
//            self.loadingIndicator.isHidden = true
//            self.imageView.isHidden = false
//        }
        self.shareExtensionData.date = Date()
        var dataArray = ExtensionUserDefaults.object(for: .share, key: .saveLink) ?? [ShareExtentionData]()
        dataArray.append(self.shareExtensionData)
    
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
//        imageView.isHidden = true
//        view.subviews.forEach {
//            if $0.tag != 2020 {
//                $0.removeFromSuperview()
//            }
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let typeURL = String(kUTTypeURL)
        let textTypes = [String(kUTTypeText),
                         String(kUTTypePlainText),
                         String(kUTTypeUTF8PlainText),
                         String(kUTTypeUTF16PlainText)]
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let urlItemProvider = extensionItem.attachments?.filter { $0.hasItemConformingToTypeIdentifier(typeURL) }.first
        guard let itemProvider = urlItemProvider ?? extensionItem.attachments?.first else {
            handleFailure()
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { [weak self] (item, error) -> Void in
                guard let strongSelf = self, let url = item as? URL else {
                    self?.handleFailure()
                    return
                }
                strongSelf.handleURL(url)
            }
            return
        }

        var handled = false
        for type in textTypes where itemProvider.hasItemConformingToTypeIdentifier(type) {
            itemProvider.loadItem(forTypeIdentifier: type, options: nil) { [weak self] (item, error) -> Void in
                guard let strongSelf = self, let string = item as? String else {
                    self?.handleFailure()
                    return
                }
                strongSelf.handleString(string)
            }
            handled = true
            break
        }
        if !handled {
            handleFailure()
        }
    }

    func urls(from string: String) -> [URL]? {
        do {
            let pattern = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?(\\\\?)?([=a-z0-9!#$\\%^&*-_]+)?"
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
        } else if let urls = urls(from: string), urls.count > 0 {
            let sorted = urls.filter { $0.absoluteString.contains("@") == false }
                .sorted { $0.absoluteString.count >  $1.absoluteString.count }
            if let url = sorted.first {
                handleURL(url)
            }
        } else {
            addNote(string)
        }
    }

    func handleURL(_ url: URL) {
        guard url.isFileURL == false else {
            handleFailure()
            return
        }
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
//        self.loadingIndicator.stopAnimating()
//        self.loadingIndicator.isHidden = true
//        self.imageView.image = UIImage(named: "CrossImage")
//        self.imageView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.cancel()
        }
    }
}
