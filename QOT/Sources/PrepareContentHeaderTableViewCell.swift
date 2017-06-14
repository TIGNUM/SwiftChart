//
//  PrepareContentHeaderTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol PrepareContentHeaderTableViewCellDelegate: class {
    func didPressReadMore(readMoreID: Int?, cell: UITableViewCell)
}

class PrepareContentHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!

    weak var delegate: PrepareContentHeaderTableViewCellDelegate?
    var readMoreID: Int?
    var contentText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = UIColor.blackTwo
    }

    func setCell(title: String, contentText: String, readMoreID: Int?, position: Int, isExpanded: Bool) {
        headerLabel.text = title
        bottomSeparator.isHidden = isExpanded
        positionLabel.text = (position > 9 ? "." : ".0") + "\(position)"

        self.readMoreID = readMoreID
        self.contentText = contentText

        iconImageView.image = isExpanded ? R.image.prepareContentMinusIcon() : R.image.prepareContentPlusIcon()

        updateContent(isExpanded: isExpanded)
    }
    
    func updateContent(isExpanded: Bool) {
        contentLabel.isHidden = !isExpanded
        readMoreButton.isHidden = !isExpanded

        if isExpanded {

            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.prepareAndSetTextAttributes(text: contentText, font: UIFont(name: "BentonSans-Book", size: 16)!)

            if readMoreID != nil {
                readMoreButton.prepareAndSetTitleAttributes(text: R.string.localized.prepareContentReadMore(),
                                                            font: UIFont(name: "BentonSans-Book", size: 16)!,
                                                            color: UIColor.blackTwo,
                                                            for: .normal)
                readMoreButton.addTarget(self, action: #selector(PrepareContentHeaderTableViewCell.readMore), for: .touchDown)
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
}
