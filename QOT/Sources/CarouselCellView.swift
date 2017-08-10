//
//  CarouselCellView.swift
//  QOT
//
//  Created by Type-IT on 28.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class CarouselCellView: UIView {

    // MARK: - Properties

    @IBOutlet fileprivate weak var view: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var textFieldName: UITextField!
    @IBOutlet fileprivate weak var textFieldSurname: UITextField!
    @IBOutlet fileprivate weak var textFieldSubtitle: UITextField!
    @IBOutlet fileprivate weak var textFieldMail: UITextField!
    @IBOutlet fileprivate weak var initialsLabel: UILabel!
    @IBOutlet fileprivate weak var editPictureButton: UIButton!
    @IBOutlet fileprivate weak var editImageViewName: UIImageView!
    @IBOutlet fileprivate weak var editImageViewRelationship: UIImageView!
    @IBOutlet fileprivate weak var editImageViewEmail: UIImageView!
    fileprivate var index: Index = 0
    weak var partnersViewControllerDelegate: PartnersViewControllerDelegate?
    fileprivate(set) var isEditing: Bool
    
    // MARK: - Init

    convenience init(frame: CGRect, index: Index) {
        self.init(frame: frame)

        self.index = index
    }

    override init(frame: CGRect) {
        isEditing = false
        
        super.init(frame: frame)

        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension CarouselCellView {

    func setup(with name: String?, surename: String?, email: String?, relationship: String?, initials: String?, profileImageResource: MediaResource?) {
        if let profileImageResource = profileImageResource {
            imageView.setImageFromResource(profileImageResource)
        }
        let isAvailable = profileImageResource?.isAvailable ?? false
        if isAvailable {
            editPictureButton.setTitle(R.string.localized.meSectorMyWhyPartnersAddPhoto(), for: .normal)
        } else {
            editPictureButton.setTitle(R.string.localized.meSectorMyWhyPartnersChangePhoto(), for: .normal)
        }
        textFieldName.attributedText = NSMutableAttributedString(
            string: name ?? "",
            letterSpacing: -1.1,
            font: Font.H3Subtitle
        )
        textFieldName.attributedPlaceholder = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersName(),
            letterSpacing: -1.1,
            font: Font.H3Subtitle
        )
        textFieldSurname.attributedText = NSMutableAttributedString(
            string: surename ?? "",
            letterSpacing: -1.1,
            font: Font.H3Subtitle
        )
        textFieldSurname.attributedPlaceholder = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersSurname(),
            letterSpacing: -1.1,
            font: Font.H3Subtitle
        )
        
        let grey = UIColor.white60
        textFieldMail.attributedText = NSMutableAttributedString(
            string: email ?? "",
            letterSpacing: 0,
            font: Font.H7Title,
            textColor: grey
        )
        textFieldMail.attributedPlaceholder = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersEmail(),
            letterSpacing: 0,
            font: Font.H7Title,
            textColor: grey
        )
        textFieldSubtitle.attributedText = NSMutableAttributedString(
            string: relationship ?? "",
            letterSpacing: 2, font: Font.H7Tag,
            textColor: grey
        )
        textFieldSubtitle.attributedPlaceholder = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersRelationship(),
            letterSpacing: 2, font: Font.H7Tag,
            textColor: grey
        )
        initialsLabel.attributedText = NSMutableAttributedString(
            string: initials?.uppercased() ?? "",
            letterSpacing: 2,
            font: Font.H1MainTitle,
            lineSpacing: 0,
            textColor: grey,
            alignment: .center
        )
        setupEditPictureButton()
    }

    func update(viewModel: PartnersViewModel) {
        viewModel.updateName(name: textFieldName.text!)
        viewModel.updateSurname(surname: textFieldSurname.text!)
        viewModel.updateRelationship(relationship: textFieldSubtitle.text!)
        viewModel.updateEmail(email: textFieldMail.text!)
        viewModel.save()
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
        partnersViewControllerDelegate?.didTapChangeImage(at: index)
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
        maskFoto(imageView: imageView)
        isEditing = false
    }
    
    func setupEditPictureButton() {
        // the state of the edit picture button is complicated. it only shows if:
        //  - editing
        //  - not editing AND there are initials AND there is no image
        if isEditing || (!isEditing && initialsLabel.text?.characters.count ?? 0 == 0 && imageView.image == nil) {
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

    private func maskFoto(imageView: UIImageView) {
        let clippingBorderPath = UIBezierPath.partnersHexagon
        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        imageView.layer.mask = borderMask
        imageView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        imageView.contentMode = .scaleAspectFill
    }
}
