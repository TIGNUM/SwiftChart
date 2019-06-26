//
//  MyVisionNavigationBarView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyVisionNavigationBarViewProtocol: class {
    func didShare()
}

final class MyVisionNavigationBarView: UIView {

    @IBOutlet private weak var title: UILabel!
    weak var delegate: MyVisionNavigationBarViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
        title.text = R.string.localized.myQOTToBeVisionTitle()
    }

    @IBAction func shareButtonAction(_ sender: Any) {
        delegate?.didShare()
    }
}
