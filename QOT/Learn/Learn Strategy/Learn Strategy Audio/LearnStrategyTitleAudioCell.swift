//
//  LearnStrategyTitleAudioCell.swift
//  QOT
//
//  Created by tignum on 4/26/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnStrategyTitleAudioCell: UITableViewCell, Dequeueable {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!

    func setUp(title: String, subTitle: String) {
        titleLabel.font = UIFont.bentonRegularFont(ofSize: 36)
        subTitleLabel.font = UIFont.bentonBookFont(ofSize: 11)
        titleLabel.text =  title
        subTitleLabel.text = subTitle
    }
}
