//
//  CarouselCellView.swift
//  QOT
//
//  Created by Type-IT on 28.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class CarouselCellView: UIView {

    @IBOutlet private weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldSubtitle: UITextField!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet private weak var editImageOne: UIImageView!
    @IBOutlet private weak var editImageTwo: UIImageView!
    @IBOutlet private weak var editImageThree: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    private func nibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
        maskFoto(image: imageView)
        edit(isEnabled: false)
    }

    private func loadViewFromNib() -> UIView {
        let nib = R.nib.carouselCellView()
        let nibView: UIView = (nib.instantiate(withOwner: self, options: nil).first as? UIView)!

        return nibView
    }

    private func maskFoto(image: UIImageView) {
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 93, y: 0))
        clippingBorderPath.addLine(to: CGPoint(x: 186, y: 52))
        clippingBorderPath.addLine(to: CGPoint(x: 186, y: 157))
        clippingBorderPath.addLine(to: CGPoint(x: 93, y: 210))
        clippingBorderPath.addLine(to: CGPoint(x: 0, y: 157))
        clippingBorderPath.addLine(to: CGPoint(x: 0, y: 52))
        clippingBorderPath.move(to: CGPoint(x: 93, y: 0))
        clippingBorderPath.close()

        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        image.layer.mask = borderMask
    }

    func edit(isEnabled: Bool) {
        textFieldName.isEnabled = isEnabled
        textFieldSurname.isEnabled = isEnabled
        textFieldSubtitle.isEnabled = isEnabled
        textFieldMail.isEnabled = isEnabled

        editImageOne.isHidden = (isEnabled == false)
        editImageTwo.isHidden = (isEnabled == false)
        editImageThree.isHidden = (isEnabled == false)
    }

    func update(viewModel: PartnersViewModel) {
        viewModel.updateName(name: textFieldName.text!)
        viewModel.updateSurename(surename: textFieldSurname.text!)
        viewModel.updateRelationship(relationship: textFieldSubtitle.text!)
        viewModel.updateEmail(email: textFieldMail.text!)
    }

    func setViewsTextFieldsDelegate(delegate: PartnersViewController) {
        textFieldName.delegate = delegate
        textFieldSurname.delegate = delegate
        textFieldSubtitle.delegate = delegate
        textFieldMail.delegate = delegate
    }

    func hideKeyboard() {
        textFieldName.resignFirstResponder()
        textFieldSurname.resignFirstResponder()
        textFieldSubtitle.resignFirstResponder()
        textFieldMail.resignFirstResponder()
    }

}
