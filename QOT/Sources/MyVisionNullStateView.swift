//
//  MyVisionNullStateView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 20.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyVisionNullStateViewProtocol: class {
    func editMyVisionAction()
}

final class MyVisionNullStateView: UIView {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    @IBOutlet private weak var writeButton: UIButton!

    weak var delegate: MyVisionNullStateViewProtocol?

    func setupView(with header: String, message: String, delegate: MyVisionNullStateViewProtocol?) {
        self.delegate = delegate
        backgroundColor = .carbon
        toBeVisionLabel.text = R.string.localized.myQOTToBeVisionTitle()
        writeButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        headerLabel.attributedText = formatted(headline: header)
        detailLabel.attributedText = formatted(vision: message)
    }
}

private extension MyVisionNullStateView {
    func formatted(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .sand)
    }

    func formatted(headline: String) -> NSAttributedString? {
        return NSAttributedString(string: headline.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }

    @IBAction func editMyVisionAction(_ sender: Any) {
        delegate?.editMyVisionAction()
    }
}
