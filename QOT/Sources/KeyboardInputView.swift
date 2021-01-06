//
//  KeyboardInputView.swift
//  QOT
//
//  Created by karmic on 22.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

protocol KeyboardInputViewProtocol: class {
    func didTapLeftButton()
    func didTapRightButton()
}

final class KeyboardInputView: UIView {

    // MARK: - Prooperties
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    weak var delegate: KeyboardInputViewProtocol?

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        NewThemeView.dark.apply(self)
        rightButton.corner(radius: Layout.cornerRadius20, borderColor: .white)
        leftButton.corner(radius: Layout.cornerRadius20, borderColor: .white)
        leftButton.setTitleColor(.white, for: .normal)
        updateRightButton(false)
    }

    func updateRightButton(_ isEnabled: Bool) {
        rightButton.isUserInteractionEnabled = isEnabled
        UIView.animate(withDuration: Animation.duration_02) { [weak self] in
            self?.rightButton.setTitleColor(isEnabled ? .white : .lightGrey, for: .normal)
            self?.rightButton.backgroundColor = .black
            self?.rightButton.layer.borderWidth = isEnabled ? 1 : 0
        }
    }
}

// MARK: - Action
extension KeyboardInputView {
    @IBAction func didTapLeftButton(_ sender: UIButton) {
        delegate?.didTapLeftButton()
    }

    @IBAction func didTapRightButton(_ sender: UIButton) {
        delegate?.didTapRightButton()
    }
}
