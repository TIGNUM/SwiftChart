//
//  MyVisionNavigationBarView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyVisionNavigationBarViewProtocol: class {
    func didShare()
}

final class MyVisionNavigationBarView: UIView {

    @IBOutlet private weak var title: UILabel!
    weak var delegate: MyVisionNavigationBarViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
        title.text = AppTextService.get(AppTextKey.my_qot_my_tbv_navigation_bar_view_title)
    }

    @IBAction func shareButtonAction(_ sender: Any) {
        delegate?.didShare()
    }
}
