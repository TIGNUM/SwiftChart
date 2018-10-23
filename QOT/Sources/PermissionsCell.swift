//
//  PermissionsCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol PermissionsCellDelegate: class {
    func switchDidChange(in permission: PermissionsManager.Permission.Identifier)
}

final class PermissionsCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var permissionLabel: UILabel!
    @IBOutlet private weak var permissionSwitch: UISwitch!
    private var identifier: PermissionsManager.Permission.Identifier?
    weak var delegate: PermissionsCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Setup

    func configure(identifier: PermissionsManager.Permission.Identifier, isOn: Bool) {
        self.identifier = identifier
        permissionLabel.text = identifier.rawValue.uppercased()
        permissionSwitch.setOn(isOn, animated: false)
        setSwitchState()
    }

    // MARK: - Switch tap handling

    @objc func didTapSwitch() {
        guard let identifier = identifier else { return }
        delegate?.switchDidChange(in: identifier)
        setSwitchState()
    }

    func setSwitchState() {
        permissionSwitch.alpha = permissionSwitch.isOn == true ? 1 : 0.5

        if permissionSwitch.isOn == true {
            permissionSwitch.layer.addGlowEffect(color: .white, shadowRadius: 4)
        } else {
            permissionSwitch.layer.removeGlowEffect()
        }
    }

    func backToPreviousState() {
        permissionSwitch.setOn(!permissionSwitch.isOn, animated: true)
        setSwitchState()
    }
}

// MARK: - Private

private extension PermissionsCell {

    func setupView() {
        backgroundColor = .clear
        permissionLabel.textColor = .white
        permissionSwitch.onTintColor = .clear
        permissionSwitch.tintColor = .white40
        permissionSwitch.layer.borderWidth = 1
        permissionSwitch.layer.cornerRadius = 16
        permissionSwitch.layer.borderColor = UIColor.white40.cgColor
        permissionLabel.font = .H5SecondaryHeadline
        permissionSwitch.addTarget(self, action: #selector(didTapSwitch), for: .valueChanged)
        setSwitchState()
    }
}
