//
//  PartnerCell.swift
//  QOT
//
//  Created by Sam Wyndham on 06/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol PartnerCellDelegate: class {

    func willStartEditing(in cell: PartnerCell)

    func didStartEditing(in cell: PartnerCell)

    func didTapDone(in cell: PartnerCell)

    func didTapEditPhoto(in cell: PartnerCell)

    func didTapShareButton(at partner: Partners.Partner?)
}

final class PartnerCell: UICollectionViewCell, Dequeueable {

    /*
     NOTE: In the xib `profileImageView` has a ratio constraint of `0.86`. This approximates the ratio of a hexigon
     placed in a rectangle.
     */
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var editProfileImageButton: UIButton!
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var givenNameTextField: UITextField!
    @IBOutlet private weak var familyNameTextField: UITextField!
    @IBOutlet private weak var relationshipTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private var editIconImageViews: [UIImageView]!
    private var partner: Partners.Partner?
    private var isEditing = false
    weak var delegate: PartnerCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func configure(with partner: Partners.Partner, isEditing: Bool) {
        self.partner = partner
        profileImageView.kf.setImage(with: partner.imageURL)
        givenNameTextField.text = partner.name
        familyNameTextField.text = partner.surname
        relationshipTextField.text = partner.relationship
        emailTextField.text = partner.email
        shareButton.isVisible = false

        syncViews()

        // FIXME: Cleanup

        initialsLabel.attributedText = NSAttributedString(
            string: partner.initials.uppercased(),
            letterSpacing: 2,
            font: Font.H1MainTitle,
            lineSpacing: 0,
            textColor: .white60,
            alignment: .center
        )
    }

    func setEditing(_ editing: Bool) {
        if editing == false {
            endEditing(true)
        } else {
            let textFields = [givenNameTextField, familyNameTextField, relationshipTextField, emailTextField]
            if textFields.filter({ $0!.isFirstResponder }).isEmpty {
                givenNameTextField.becomeFirstResponder()
            }
        }
        isEditing = editing
        syncViews()
    }

    func updateActionButtons(_ isVisible: Bool) {
        shareButton.isVisible = isVisible
    }

    @IBAction func didTapEditProfileImage(_ sender: UIButton) {
        delegate?.didTapEditPhoto(in: self)
    }

    @IBAction func didEditTextField(_ sender: UITextField) {
        switch sender {
        case givenNameTextField:
            partner?.name = sender.text
        case familyNameTextField:
            partner?.surname = sender.text
        case relationshipTextField:
            partner?.relationship = sender.text
        case emailTextField:
            partner?.email = sender.text
        default:
            break
        }
        initialsLabel.text = partner?.initials
    }

    @IBAction func didTapShareButton(_ sender: UIButton) {
        delegate?.didTapShareButton(at: partner)
    }
}

// MARK: - Private

private extension PartnerCell {

    struct Style {
        static let givenNameText = Attributes(letterSpacing: 1.1, font: Font.H3Subtitle)
        static let familyNameText = Attributes(letterSpacing: 1.1, font: Font.H3Subtitle)
        static let relationshipText = Attributes(letterSpacing: 2, font: Font.H7Tag, textColor: .white60)
        static let emailText = Attributes(letterSpacing: 0, font: Font.H8Title, textColor: .white60)
        static let givenNamePlaceholder = Attributes(letterSpacing: 1.1, font: Font.H3Subtitle)
        static let familyNamePlaceholder = Attributes(letterSpacing: 1.1, font: Font.H3Subtitle)
        static let relationshipPlaceholder = Attributes(letterSpacing: 2, font: Font.H7Tag, textColor: .white60)
        static let emailPlaceholder = Attributes(letterSpacing: 0, font: Font.H7Title, textColor: .white60)
    }

    func setup() {
        profileImageView.backgroundColor = UIColor.whiteLight
        givenNameTextField.defaultTextAttributes = Style.givenNameText.withStringKeys()
        familyNameTextField.defaultTextAttributes = Style.familyNameText.withStringKeys()
        relationshipTextField.defaultTextAttributes = Style.relationshipText.withStringKeys()
        emailTextField.defaultTextAttributes = Style.emailText.withStringKeys()

        givenNameTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersName().uppercased(),
            attributes: Style.givenNamePlaceholder)
        familyNameTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersSurname().uppercased(),
            attributes: Style.familyNamePlaceholder)
        relationshipTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersRelationship(),
            attributes: Style.relationshipPlaceholder)
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersEmail(),
            attributes: Style.emailPlaceholder)
    }

    func syncViews() {
        syncProfileImageButton()
        syncEditIconImageViews()
        syncInitialsLabel()
    }

    func syncInitialsLabel() {
        guard let partner = partner else { return }

        let partnerHasPhoto = partner.imageURL != nil
        initialsLabel.isHidden = partnerHasPhoto || isEditing
    }

    func syncProfileImageButton() {
        guard let partner = partner else { return }

        let partnerHasPhoto = partner.imageURL != nil
        let partnerHasInitials = partner.initials.isEmpty == false
        editProfileImageButton.isHidden = !isEditing && (partnerHasPhoto || partnerHasInitials)
    }

    func syncEditIconImageViews() {
        editIconImageViews.forEach { $0.isHidden = !isEditing }
    }
}

extension Dictionary where Key == NSAttributedStringKey, Value == Any {

    func withStringKeys() -> [String: Value] {
        return reduce(into: [:], { $0[$1.key.rawValue] = $1.value })
    }
}

extension PartnerCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.willStartEditing(in: self)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didStartEditing(in: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didTapDone(in: self)
        return true
    }
}

private extension UITextField {

    func configurePrinciple(title: String?, placeholder: String) {
        autocapitalizationType = .allCharacters
        attributedText = title.map { NSAttributedString(string: $0, letterSpacing: -1.1, font: Font.H3Subtitle)}
        attributedPlaceholder = NSAttributedString(string: placeholder, letterSpacing: -1.1, font: Font.H3Subtitle)
    }
}
