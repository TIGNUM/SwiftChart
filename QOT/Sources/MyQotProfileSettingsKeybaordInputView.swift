//
//  MyQotProfileSettingsKeybaordInputView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 22.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyQotProfileSettingsKeybaordInputViewProtocol: class {
    func didCancel()
    func didSave()
}

final class MyQotProfileSettingsKeybaordInputView: UIView {

    var shouldAllowSave: Bool = false {
        willSet {
            saveButton.backgroundColor = newValue == true ? .sand : .sand08
            let titleColor: UIColor = newValue == true ? .accent : .sand30
            saveButton.setTitleColor(titleColor, for: .normal)
        }
    }

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var fadeView: UIView!

    weak var delegate: MyQotProfileSettingsKeybaordInputViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.corner(radius: Layout.cornerRadius20, borderColor: .clear)
        closeButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        shouldAllowSave = false
        fadeView.addFadeView(at: .bottom, height: frame.size.height, primaryColor: .carbon, fadeColor: colorMode.fade)
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        delegate?.didCancel()
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        delegate?.didSave()
    }
}
