//
//  TBVDataGraphHeader.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TBVDataGraphHeaderView: UITableViewHeaderFooterView, Dequeueable {

    @IBOutlet private weak var title: UILabel!

    func configure(title: NSAttributedString?) {
        self.title.attributedText = title
    }
}
