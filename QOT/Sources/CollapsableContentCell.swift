//
//  CollapsableContentCell.swift
//  QOT
//
//  Created by Lee Arromba on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol CollapsableContentCellDelegate: class {
    func collapsableContentCell(_ cell: CollapsableContentCell, didTapCheckAt indexPath: IndexPath)
}

final class CollapsableContentCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var suggestionLabel: UILabel!
    @IBOutlet private weak var readImageView: UIImageView!
    weak var delegate: CollapsableContentCellDelegate?
    var indexPath: IndexPath?

    var isChecked: Bool? {
        didSet { reload() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 0)
        readImageView.image = R.image.ic_seen_of()?.withRenderingMode(.alwaysTemplate)
        readImageView.tintColor = .carbon70
    }

    func setTitleText(_ text: String?, duration: String, isSuggestion: Bool) {
        label.text = text
        durationLabel.text = duration
        suggestionLabel.isHidden = isSuggestion == false
    }

    // MARK: - private
    private func reload() {
        guard let isChecked = isChecked else { return }
        let image = (isChecked == true) ? R.image.ic_radio_selected() : R.image.ic_radio_unselected()
        button.setImage(image, for: .normal)
    }

    // MARK: - action
    @IBAction private func buttonPressed(_ sender: UIButton) {
        guard let delegate = delegate, let indexPath = indexPath else { return }
        delegate.collapsableContentCell(self, didTapCheckAt: indexPath)
    }
}
