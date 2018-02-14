//
//  CollapsableContentCell.swift
//  QOT
//
//  Created by Lee Arromba on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol CollapsableContentCellDelegate: class {
    func collapsableContentCell(_ cell: CollapsableContentCell, didPressCheckButtonForIndexPath indexPath: IndexPath)
}

class CollapsableContentCell: UITableViewCell {
    static let nibName = "CollapsableContentCell"

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    var isChecked: Bool? {
        didSet {
            reload()
        }
    }
    var indexPath: IndexPath?
    weak var delegate: CollapsableContentCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 20)
    }

    func setTitleText(_ text: String?) {
        label.attributedText = NSMutableAttributedString(
            string: text ?? "",
            letterSpacing: 2,
            font: UIFont.simpleFont(ofSize: 14.0),
            textColor: .white)
    }

    // MARK: - private

    private func reload() {
        guard let isChecked = isChecked else {
            return
        }
        let image = (isChecked == true) ? R.image.check() : R.image.circle()
        button.setBackgroundImage(image, for: .normal)
    }

    // MARK: - action

    @IBAction private func buttonPressed(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else {
            return
        }
        delegate.collapsableContentCell(self, didPressCheckButtonForIndexPath: indexPath)
    }
}
