//
//  CollapsableCell.swift
//  QOT
//
//  Created by Lee Arromba on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol CollapsableCellDelegate: class {
    func collapsableCell(_ cell: CollapsableCell, didPressCollapseButtonForIndexPath indexPath: IndexPath)
}

class CollapsableCell: UITableViewCell {
    static let nibName = "CollapsableCell"

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    var isOpen: Bool? {
        didSet {
            reload()
        }
    }
    var indexPath: IndexPath?
    weak var delegate: CollapsableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    }

    func setTitleText(_ text: String?) {
        label.attributedText = NSMutableAttributedString(
            string: text?.uppercased() ?? "",
            letterSpacing: 2,
            font: .H6NavigationTitle,
            textColor: UIColor.white)
    }

    // MARK: - private

    private func reload() {
        guard let isOpen = isOpen else {
            return
        }
        let image = (isOpen == true) ? R.image.prepareContentMinusIcon() : R.image.prepareContentPlusIcon()
        button.setImage(image, for: .normal)
    }

    // MARK: - action

    @IBAction private func buttonPressed(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else {
            return
        }
        delegate.collapsableCell(self, didPressCollapseButtonForIndexPath: indexPath)
    }
}
