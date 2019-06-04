//
//  ProfileSettingsFooterView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol ProfileSettingsFooterViewProtocol: class {
    func didSave()
    func didCancel()
}

final class ProfileSettingsFooterView: UIView {
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    weak var delegate: ProfileSettingsFooterViewProtocol?
    var isEnabled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.setTitleColor(.sand30, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .sand
        saveButton.corner(radius: Layout.CornerRadius.cornerRadius12.rawValue)
        cancelButton.corner(radius: Layout.CornerRadius.cornerRadius12.rawValue, borderColor: .accent30, borderWidth: 1)
        cancelButton.setTitle("Cancel", for: .normal)
    }
    
    func setupView(isEnabled: Bool) {
        self.isEnabled = isEnabled
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .sand : .sand08
        saveButton.setTitleColor(isEnabled ? .accent : .sand30, for: .normal)
    }
}

extension ProfileSettingsFooterView {
    @IBAction func saveAction(_ sender: UIButton) {
        delegate?.didSave()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        delegate?.didCancel()
    }
}
