//
//  MyQotSupportNovartisViewController.swift
//  QOT
//
//  Created by karmic on 17.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotSupportNovartisViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    var header: String?
    var subTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = header
        subtitleLabel.text = subTitle
    }
}
