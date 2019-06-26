//
//  MyToBeVisionNullStateViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyVisionNullStateViewController: UIViewController {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var autogenerateButton: UIButton!
    @IBOutlet private weak var writeButton: UIButton!

    var interactor: MyVisionNullStateInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    private func formatted(headline: String) -> NSAttributedString? {
        return NSAttributedString(string: headline.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }

    private func formatted(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .sand)
    }
}

extension MyVisionNullStateViewController: MyVisionNullStateViewControllerInterface {
    func setupView() {
        view.backgroundColor = .carbon
        toBeVisionLabel.text = R.string.localized.myQOTToBeVisionTitle()
        backButton.corner(radius: backButton.frame.size.width/2, borderColor: .accent40)
        autogenerateButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        writeButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        headerLabel.attributedText = formatted(headline: interactor?.headlinePlaceholder ?? "")
        detailLabel.attributedText = formatted(vision: interactor?.messagePlaceholder ?? "")
    }
}
