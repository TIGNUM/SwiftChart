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

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var fadeView: UIImageView!

    weak var delegate: MyVisionEditDetailsKeyboardInputViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitleColor(.lightGrey, for: .disabled)
        closeButton.corner(radius: closeButton.frame.size.width/2, borderColor: .white)
        closeButton.imageView?.tintColor = .white
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        delegate?.didCancel()
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        delegate?.didSave()
    }
}
