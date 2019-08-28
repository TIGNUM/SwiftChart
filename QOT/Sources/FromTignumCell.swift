//
//  FromTignumCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromTignumCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var heightOfText: NSLayoutConstraint!
    @IBOutlet private weak var fromTignumText: UILabel!
    private var isLabelAtMaxHeight = false
    @IBOutlet private weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeBorder.accent.apply(button)
    }

    @IBAction func discoverButton(_ sender: Any) {
        if isLabelAtMaxHeight {
            isLabelAtMaxHeight = false
            heightOfText.constant = 100
        } else {
//             link to more details
            isLabelAtMaxHeight = true
            heightOfText.constant = 400
        }
    }

    func configure(with viewModel: FromTignumCellViewModel?) {
        fromTignumText.text = viewModel?.text
        titleLabel.text = viewModel?.title
    }
}
