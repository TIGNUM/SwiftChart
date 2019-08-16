//
//  MyPeakperformanceTitleCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceTitleCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var title: UILabel!

    func configure(with: MypeakperformanceTitleModel?) {
        title.text = with?.title
    }
}
