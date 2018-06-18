//
//  PartnerEditTextFieldCell.swift
//  QOT
//
//  Created by karmic on 17.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditTextFieldCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var relationshipTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var verticalSpacingLayoutConstraints: [NSLayoutConstraint]!
    private var interactor: PartnerEditInteractorInterface?
    private var partner: Partners.Partner?

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        nameTextField.backgroundColor = .clear
        surnameTextField.backgroundColor = .clear
        relationshipTextField.backgroundColor = .clear
        emailTextField.backgroundColor = .clear
    }

    // MARK: - public

    func configure(partner: Partners.Partner?, interactor: PartnerEditInteractorInterface?, verticalSpace: CGFloat? = 10) {
        self.interactor = interactor
        self.partner = partner
        setupTextFields(partner: partner)
        updateVerticalSpace(verticalSpace!)
    }
}

// MARK: - Private

private extension PartnerEditTextFieldCell {

    func setupTextFields(partner: Partners.Partner?) {
        nameTextField.attributedPlaceholder = attributedPlaceholder(string: "NAME")
        nameTextField.attributedText = attributedText(string: partner?.name ?? "")
        surnameTextField.attributedPlaceholder = attributedPlaceholder(string: "SURNAME")
        surnameTextField.attributedText = attributedText(string: partner?.surname ?? "")
        relationshipTextField.attributedPlaceholder = attributedPlaceholder(string: "RELATIONSHIP")
        relationshipTextField.attributedText = attributedText(string: partner?.relationship ?? "")
        emailTextField.attributedPlaceholder = attributedPlaceholder(string: "EMAIL")
        emailTextField.attributedText = attributedText(string: partner?.email ?? "")
    }

    func attributedPlaceholder(string: String) -> NSAttributedString {
        return NSMutableAttributedString(string: string,
                                         letterSpacing: 2,
                                         font: Font.H8Title,
                                         textColor: .white60,
                                         alignment: .left)
    }

    func attributedText(string: String) -> NSAttributedString {
        return NSMutableAttributedString(string: string,
                                         letterSpacing: 0,
                                         font: Font.PText,
                                         textColor: .white,
                                         alignment: .left)
    }

    func updateVerticalSpace(_ space: CGFloat) {
        for verticalConstraint in verticalSpacingLayoutConstraints {
            verticalConstraint.constant = space
        }
        self.updateConstraintsIfNeeded()
    }
}

// MARK: - UITextFieldDelegate

extension PartnerEditTextFieldCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            surnameTextField.becomeFirstResponder()
            return false
        }
        if textField == surnameTextField {
            relationshipTextField.becomeFirstResponder()
            return false
        }
        if textField == relationshipTextField {
            emailTextField.becomeFirstResponder()
            return false
        }
        if textField == emailTextField {
            endEditing(true)
            return true
        }
        return true
    }
}
