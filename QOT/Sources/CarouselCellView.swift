//
//  CarouselCellView.swift
//  QOT
//
//  Created by Type-IT on 28.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol CarouselCellViewDelegate: class {

    func didTapChangePicture(cell: CarouselCellView)
}

final class CarouselCellView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldSubtitle: UITextField!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var editPictureButton: UIButton!
    @IBOutlet private weak var editImageViewName: UIImageView!
    @IBOutlet private weak var editImageViewRelationship: UIImageView!
    @IBOutlet private weak var editImageViewEmail: UIImageView!
    private(set) var partner: Partners.Partner?
    weak var delegate: CarouselCellViewDelegate?
    private(set) var isEditing: Bool

    // MARK: - Init

    override init(frame: CGRect) {
        isEditing = false

        super.init(frame: frame)

        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func didEditRelationship(_ sender: UITextField) {
        partner?.relationship = sender.text
    }
    @IBAction func didEditEmail(_ sender: UITextField) {
        partner?.email = sender.text
    }
    @IBAction func didEditName(_ sender: UITextField) {
        partner?.name = sender.text
    }
    @IBAction func didEditSurname(_ sender: UITextField) {
        partner?.surname = sender.text
    }
}

// MARK: - Public

extension CarouselCellView {

    func configure(partner: Partners.Partner) {
        self.partner = partner
        imageView.kf.setImage(with: partner.imageURL)
        if partner.imageURL == nil {
            editPictureButton.setTitle(R.string.localized.meSectorMyWhyPartnersAddPhoto(), for: .normal)
        } else {
            editPictureButton.setTitle(R.string.localized.meSectorMyWhyPartnersChangePhoto(), for: .normal)
        }
        textFieldName.autocapitalizationType = .allCharacters
        textFieldName.attributedText = partner.name.map { NSAttributedString(
            string: $0,
            letterSpacing: -1.1,
            font: Font.H3Subtitle
            )
        }
        textFieldName.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersName().uppercased(),
            letterSpacing: -1.1,
            font: Font.H3Subtitle
        )
        textFieldSurname.autocapitalizationType = .allCharacters
        textFieldSurname.attributedText = partner.surname.map { NSAttributedString(
            string: $0,
            letterSpacing: -1.1,
            font: Font.H3Subtitle
            )
        }
        textFieldSurname.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersSurname().uppercased(),
            letterSpacing: -1.1,
            font: Font.H3Subtitle
        )

        let grey = UIColor.white60
        textFieldMail.attributedText = partner.email.map { NSAttributedString(
            string: $0,
            letterSpacing: 0,
            font: Font.H8Title,
            textColor: grey
            )
        }
        textFieldMail.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersEmail(),
            letterSpacing: 0,
            font: Font.H7Title,
            textColor: grey
        )
        textFieldSubtitle.attributedText = partner.relationship.map { NSAttributedString(
            string: $0,
            letterSpacing: 2, font: Font.H7Tag,
            textColor: grey
            )
        }
        textFieldSubtitle.attributedPlaceholder = NSAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersRelationship(),
            letterSpacing: 2,
            font: Font.H7Tag,
            textColor: grey
        )
        initialsLabel.attributedText = NSAttributedString(
            string: partner.initials.uppercased(),
            letterSpacing: 2,
            font: Font.H1MainTitle,
            lineSpacing: 0,
            textColor: grey,
            alignment: .center
        )
        setupEditPictureButton()
    }

    func edit(isEnabled: Bool) {
        isEditing = isEnabled

        initialsLabel.isHidden = isEnabled
        textFieldName.isEnabled = isEnabled
        textFieldSurname.isEnabled = isEnabled
        textFieldSubtitle.isEnabled = isEnabled
        textFieldMail.isEnabled = isEnabled

        setupEditPictureButton()
        setupEditImageView(imageView: editImageViewEmail, isHidden: (isEnabled == false))
        setupEditImageView(imageView: editImageViewRelationship, isHidden: (isEnabled == false))
        setupEditImageView(imageView: editImageViewName, isHidden: (isEnabled == false))

        if isEnabled == true {
            textFieldName.becomeFirstResponder()
        }
    }

    func hideKeyboard() {
        view.endEditing(true)
    }

    func setViewsTextFieldsDelegate(delegate: PartnersViewController) {
        textFieldName.delegate = delegate
        textFieldSurname.delegate = delegate
        textFieldSubtitle.delegate = delegate
        textFieldMail.delegate = delegate
    }
}

// MARK: - Actions

private extension CarouselCellView {

    @IBAction func didTapChangePicture(sender: UIButton) {
        delegate?.didTapChangePicture(cell: self)
    }
}

// MARK: - Private

private extension CarouselCellView {

    func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)

        imageView.applyHexagonMask()
        imageView.backgroundColor = UIColor.whiteLight

        isEditing = false
    }

    func setupEditPictureButton() {
        // the state of the edit picture button is complicated. it only shows if:
        //  - editing
        //  - not editing AND there are initials AND there is no image
        if isEditing || (!isEditing && initialsLabel.text?.count ?? 0 == 0 && imageView.image == nil) {
            editPictureButton.isHidden = false
        } else {
            editPictureButton.isHidden = true
        }
    }

    func setupEditImageView(imageView: UIImageView, isHidden: Bool) {
        guard isHidden == false else {
            imageView.isHidden = true
            return
        }

        imageView.isHidden = false
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.image = R.image.ic_edit()
    }

    private func loadViewFromNib() -> UIView {
        let nib = R.nib.carouselCellView()
        let nibView: UIView = (nib.instantiate(withOwner: self, options: nil).first as? UIView)!

        return nibView
    }
}
