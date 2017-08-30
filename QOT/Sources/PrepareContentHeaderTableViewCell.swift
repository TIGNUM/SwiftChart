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

class PrepareContentHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!

    weak var delegate: PrepareContentHeaderTableViewCellDelegate?
    var readMoreID: Int?
    var contentText = ""

    var displayMode: PrepareContentViewModel.DisplayMode = .normal

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear

        readMoreButton.addTarget(self, action: #selector(PrepareContentHeaderTableViewCell.readMore), for: .touchDown)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PrepareContentHeaderTableViewCell.checkboxTapped))
        checkboxImageView.addGestureRecognizer(gestureRecognizer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()        
    }

    func setCell(title: String, contentText: String, readMoreID: Int?, position: Int, isExpanded: Bool, displayMode: PrepareContentViewModel.DisplayMode = .normal, isChecked: Bool = false) {

        bottomSeparator.backgroundColor = .black30

        headerLabel.prepareAndSetTextAttributes(text: title.uppercased(), font: Font.H4Headline, lineSpacing: 3, characterSpacing: -0.8)
        headerLabel.textColor = .black

        positionLabel.text = (position > 9 ? "." : ".0") + "\(position)"
        positionLabel.font = Font.H4Headline

        self.readMoreID = readMoreID
        self.contentText = contentText
        self.displayMode = displayMode

        iconImageView.image = isExpanded ? R.image.prepareContentMinusIcon() : R.image.prepareContentPlusIcon()

        switch displayMode {
        case .normal:
            positionLabel.isHidden = false
            checkboxImageView.isHidden = true
        case .checkbox:
            positionLabel.isHidden = true
            checkboxImageView.isHidden = false
            checkboxImageView.image = UIImage(named: isChecked ? "checkbox_checked" : "checkbox_unchecked")
        }

        updateContent(isExpanded: isExpanded)
    }

    func updateContent(isExpanded: Bool) {

        if isExpanded {
            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.prepareAndSetTextAttributes(text: contentText, font: Font.DPText)

            if readMoreID != nil {
                readMoreButton.prepareAndSetTitleAttributes(text: R.string.localized.prepareContentReadMore(),
                                                            font: Font.DPText,
                                                            color: .black40,
                                                            for: .normal)
            } else {
                readMoreButton.isHidden = true
            }
        }
    }
    
    func setExpandImageState(isExpanded: Bool) {
    }
    
    func readMore() {
        delegate?.didPressReadMore(readMoreID: readMoreID, cell: self)
    }

    func checkboxTapped() {
        delegate?.didTapCheckbox(cell: self)
        self.layoutIfNeeded()
    }
}
