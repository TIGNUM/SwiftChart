//
//  WhatsHotDetailViewController.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotDetailViewController: ComponentDetailViewController {

    @IBOutlet weak var whatsHotComponentView: WhatsHotComponentView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(title: String?, publishDate: Date?, author: String?, timeToRead: String?, imageURL: URL?) {
        whatsHotComponentView.configure(title: title,
                                        publishDate: publishDate,
                                        author: author,
                                        timeToRead: timeToRead,
                                        imageURL: imageURL)
    }
}
