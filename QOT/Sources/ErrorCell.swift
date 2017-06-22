//
//  ErrorCell.swift
//  QOT
//
//  Created by Sam Wyndham on 13.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ErrorCell: UITableViewCell, Dequeueable {

    func configure(text: String) {
        textLabel?.textColor = .red
        textLabel?.text = text
        selectionStyle = .none
    }
}
