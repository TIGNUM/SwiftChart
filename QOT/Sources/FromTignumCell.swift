//
//  FromTignumCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromTignumCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var heightOfText: NSLayoutConstraint!
    @IBOutlet private weak var fromTignumText: UILabel!
    private var isLabelAtMaxHeight = false
    @IBOutlet private weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.corner(radius: 20)
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

    func configure(text: String?) {
        fromTignumText.text = text
    }
}
