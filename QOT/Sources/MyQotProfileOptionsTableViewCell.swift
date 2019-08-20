//
//  MyQotProfileOptionsTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileOptionsTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var subHeadingLabel: UILabel!
    @IBOutlet private weak var separator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.backgroundColor = .accent10
    }

    func configure(_ data: MyQotProfileModel.TableViewPresentationData) {
        headingLabel.text = data.heading.uppercased()
        subHeadingLabel.text = data.subHeading
    }
}
