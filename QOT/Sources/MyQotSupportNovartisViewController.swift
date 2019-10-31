//
//  MyQotSupportNovartisViewController.swift
//  QOT
//
//  Created by karmic on 17.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotSupportNovartisViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet private weak var headerView: UIView!
    var baseHeaderview: QOTBaseHeaderView?
    var header: String?
    var subTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView)
        baseHeaderview?.configure(title: header, subtitle: subTitle)
    }
}
