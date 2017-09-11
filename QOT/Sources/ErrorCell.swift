//
//  ErrorCell.swift
//  QOT
//
//  Created by Sam Wyndham on 13.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ErrorCell: UITableViewCell, Dequeueable {

    func configure(text: String, item: ContentItem) {
        textLabel?.numberOfLines = 0
        textLabel?.textColor = .red
        textLabel?.text = String(format: "%@\nfomat: %@\ntitle: %@\nid: %d",
                                 text,
                                 item.format,
                                 item.valueText ?? "" ,
                                 item.remoteID.value ?? 0)
        selectionStyle = .none
    }
}
