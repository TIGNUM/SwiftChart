//
//  TBVDataGraphSubHeadingTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TBVDataGraphSubHeadingTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var title: UILabel!

    func configure(subHeading: String?) {
        ThemeText.tbvTrackerBody.apply(subHeading, to: title)
    }
}
