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
            saveButton.layer.borderColor = newValue == true ? UIColor.white.cgColor : UIColor.clear.cgColor
            let titleColor: UIColor = newValue == true ? .white : .darkGray
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
        closeButton.corner(radius: Layout.cornerRadius20, borderColor: .white)
        shouldAllowSave = false
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        delegate?.didCancel()
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        delegate?.didSave()
    }
}
