//
//  SideBarShareAction.swift
//  QOT
//
//  Created by tignum on 5/3/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SideBarShareAction: UITableViewCell, Dequeueable {

    @IBOutlet private weak var shareTextLabel: UILabel!

    func setUp(text: NSAttributedString) {
        shareTextLabel.attributedText = text
    }
}
