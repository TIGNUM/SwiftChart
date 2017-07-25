//
//  ErrorCell.swift
//  QOT
//
//  Created by Sam Wyndham on 13.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ErrorCell: UITableViewCell, Dequeueable {

    func configure(text: String, format: String = "") {
        textLabel?.textColor = .red
        textLabel?.text = String(format: "%@ %@", text, format)
        selectionStyle = .none
    }
}
