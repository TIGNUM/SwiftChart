//
//  DeleteConfirmationViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class DeleteConfirmationViewController: UIViewController {

    weak var delegate: MyPrepsViewControllerDelegate?

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func yesContinueButton(_ sender: Any) {
        delegate?.confirmDeleteButton(sender)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
            return [roundedBarBurtonItem(title: R.string.localized.buttonTitleYesContinue(), action: #selector(yesContinueButton(_:))),
                    roundedBarBurtonItem(title: R.string.localized.buttonTitleCancel(), action: #selector(cancelButton(_:)))]
    }

    @objc public func roundedBarBurtonItem(title: String, action: Selector) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: action)
        let item = UIBarButtonItem(customView: button)
        item.tintColor = colorMode.tint
        return item
    }
}
