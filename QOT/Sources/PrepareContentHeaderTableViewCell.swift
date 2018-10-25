//
//  PrepareContentHeaderTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentHeaderTableViewCellDelegate: class {
    func didPressReadMore(readMoreID: Int?, cell: UITableViewCell)
    func didTapCheckbox(cell: UITableViewCell)
}

final class PrepareContentHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var bottomSeparator: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var checkboxImageView: UIImageView!
    @IBOutlet private weak var headerLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    weak var delegate: PrepareContentHeaderTableViewCellDelegate?
    var readMoreID: Int?
    var contentText = ""
    var displayMode: PrepareContentViewModel.DisplayMode = .normal

    override func awakeFromNib() {
        super.awakeFromNib()
        checkboxImageView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        readMoreButton.addTarget(self, action: #selector(PrepareContentHeaderTableViewCell.readMore), for: .touchDown)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PrepareContentHeaderTableViewCell.checkboxTapped))
        checkboxImageView.addGestureRecognizer(gestureRecognizer)
    }

    func setCell(title: String,
                 contentText: String,
                 readMoreID: Int?,
                 position: Int,
                 isExpanded: Bool,
                 displayMode: PrepareContentViewModel.DisplayMode = .normal,
                 isChecked: Bool = false) {
        bottomSeparator.backgroundColor = .nightModeBlack30
        headerLabel.setAttrText(text: title.uppercased(),
                                font: .H4Headline,
                                lineSpacing: 3,
                                characterSpacing: -0.8,
                                color: .nightModeBlack)
        self.readMoreID = readMoreID
        self.contentText = contentText
        self.displayMode = displayMode
        syncButtonImage(isExpanded: isExpanded)

        switch displayMode {
        case .normal:
            checkboxImageView.isHidden = true
            headerLabelLeftConstraint.constant = -10
        case .checkbox:
            checkboxImageView.isHidden = false
            checkboxImageView.image = UIImage(named: isChecked ? "checkbox_checked" : "checkbox_unchecked")
        }

        updateContent(isExpanded: isExpanded)
        layoutIfNeeded()
    }

    private func updateContent(isExpanded: Bool) {
        if isExpanded {
            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.setAttrText(text: contentText, font: .DPText, color: .nightModeSubFont)
            if readMoreID != nil {
                readMoreButton.prepareAndSetTitleAttributes(text: R.string.localized.prepareContentReadMore(),
                                                            font: .DPText,
                                                            color: .nightModeBlack40,
                                                            for: .normal)
            } else {
                readMoreButton.isHidden = true
            }
        }
    }

    private func syncButtonImage(isExpanded: Bool) {
        let imageDown = R.image.ic_minimize()?.tintedImage(color: .gray).withHorizontallyFlippedOrientation()
        let imageUp = R.image.ic_minimize_up()?.tintedImage(color: .gray).withHorizontallyFlippedOrientation()
        iconImageView.image = isExpanded == true ? imageUp : imageDown
    }

    @objc func readMore() {
        delegate?.didPressReadMore(readMoreID: readMoreID, cell: self)
    }

    @objc func checkboxTapped() {
        delegate?.didTapCheckbox(cell: self)
        self.layoutIfNeeded()
    }
}
