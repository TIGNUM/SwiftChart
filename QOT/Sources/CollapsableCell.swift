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

final class CollapsableCell: UITableViewCell {
    static let nibName = "CollapsableCell"
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var selectionCountLabel: UILabel!

    var isOpen: Bool? {
        didSet {
            reload()
        }
    }
    var indexPath: IndexPath?
    weak var delegate: CollapsableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
    }

    func setTitleText(_ text: String?, selectionCount: Int, strategyCount: Int) {
        selectionCountLabel.text = String(format: "%d/%d", selectionCount, strategyCount)
        label.text = text
    }

    // MARK: - private

    private func reload() {
        guard let isOpen = isOpen else { return }
        let image = (isOpen == true) ? R.image.ic_minus() : R.image.ic_plus()
        button.setImage(image, for: .normal)
    }

    // MARK: - action

    @IBAction private func buttonPressed(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else { return }
        delegate.collapsableCell(self, didPressCollapseButtonForIndexPath: indexPath)
    }
}
