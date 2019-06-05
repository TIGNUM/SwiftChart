//
//  MyVisionEditDetailsKeyboardInputView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyVisionEditDetailsKeyboardInputViewProtocol: class {
    func didCancel()
    func didSave()
}

final class MyVisionEditDetailsKeyboardInputView: UIView {

    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var fadeView: UIView!

    weak var delegate: MyVisionEditDetailsKeyboardInputViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        closeButton.corner(radius: closeButton.frame.size.width/2, borderColor: .accent40)
        fadeView.addFadeView(at: .bottom, height: frame.size.height, primaryColor: .carbon, fadeColor: colorMode.fade)
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        delegate?.didCancel()
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        delegate?.didSave()
    }
}
