//
//  KeyboardInputView.swift
//  QOT
//
//  Created by karmic on 22.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

protocol KeyboardInputViewProtocol: class {
    func didCancel()
    func didCreateTeam()
}

final class KeyboardInputView: UIView {

    @IBOutlet weak var createButton: UIButton!
    weak var delegate: KeyboardInputViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        createButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        updateCreateButton(false)
    }

    func updateCreateButton(_ isEnabled: Bool) {
        createButton.isUserInteractionEnabled = isEnabled
        UIView.animate(withDuration: Animation.duration_02) { [weak self] in
            self?.createButton.setTitleColor(isEnabled ? .accent : .sand30, for: .normal)
            self?.createButton.backgroundColor = isEnabled ? .carbon : .sand08
            self?.createButton.layer.borderWidth = isEnabled ? 1 : 0
        }
    }
}

// MARK: - Action
extension KeyboardInputView {
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.didCancel()
    }

    @IBAction func didTapCreateTeam(_ sender: Any) {
        delegate?.didCreateTeam()
    }
}
