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
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.shareExtensionData.title = self.textView.text
        self.shareExtensionData.date = Date()
        ExtensionUserDefaults.set(self.shareExtensionData, for: .saveLink, in: .share)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QOT"

        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        guard let itemProvider = extensionItem.attachments?.first else {
            return
        }
        let propertyList = String(kUTTypeURL)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { [weak self] (item, error) -> Void in
                guard let strongSelf = self, let url = item as? URL else { return }
                OperationQueue.main.addOperation {
                    strongSelf.shareExtensionData.url = url.absoluteString
                    strongSelf.shareExtensionData.title = strongSelf.textView.text
                }
            })
        }
    }
}
