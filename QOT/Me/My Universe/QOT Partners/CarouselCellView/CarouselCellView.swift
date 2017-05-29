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

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldSubtitle: UITextField!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var editPictureButton: UIButton!
    @IBOutlet fileprivate weak var editImageViewName: UIImageView!
    @IBOutlet fileprivate weak var editImageViewRelationship: UIImageView!
    @IBOutlet fileprivate weak var editImageViewEmail: UIImageView!
    fileprivate var index: Index = 0
    weak var partnersViewControllerDelegate: PartnersViewControllerDelegate?

    // MARK: - Init

    convenience init(frame: CGRect, index: Index) {
        self.init(frame: frame)
        self.index = index
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViewsTextFieldsDelegate(delegate: PartnersViewController) {
        textFieldName.delegate = delegate
        textFieldSurname.delegate = delegate
        textFieldSubtitle.delegate = delegate
        textFieldMail.delegate = delegate
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
        edit(isEnabled: false)
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
        imageView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        imageView.contentMode = .scaleAspectFill
    }
}

private extension CarouselCellView {

    @IBAction func didTapChangePicture(sender: UIButton) {
        partnersViewControllerDelegate?.didTapChangeImage(at: index)
    }
}

// MARK: - Public

extension CarouselCellView {

    func edit(isEnabled: Bool) {
        textFieldName.isEnabled = isEnabled
        textFieldSurname.isEnabled = isEnabled
        textFieldSubtitle.isEnabled = isEnabled
        textFieldMail.isEnabled = isEnabled
        editPictureButton.isHidden = (isEnabled == false)
        setupEditImageView(imageView: editImageViewEmail, isHidden: (isEnabled == false))
        setupEditImageView(imageView: editImageViewRelationship, isHidden: (isEnabled == false))
        setupEditImageView(imageView: editImageViewName, isHidden: (isEnabled == false))

        if isEnabled == true {
            textFieldName.becomeFirstResponder()
        }
    }

    func update(viewModel: PartnersViewModel) {
        viewModel.updateName(name: textFieldName.text!)
        viewModel.updateSurename(surename: textFieldSurname.text!)
        viewModel.updateRelationship(relationship: textFieldSubtitle.text!)
        viewModel.updateEmail(email: textFieldMail.text!)
    }

    func hideKeyboard() {
        textFieldName.resignFirstResponder()
        textFieldSurname.resignFirstResponder()
        textFieldSubtitle.resignFirstResponder()
        textFieldMail.resignFirstResponder()
    }
}
