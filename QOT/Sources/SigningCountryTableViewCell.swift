//
//  SigningCountryTableViewCell.swift
//  QOT
//
//  Created by karmic on 08.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCountryTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var countryLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        tintColor = .aquaMarine
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
    }
}

// MARK: - Public

extension SigningCountryTableViewCell {

    func configure(country: String, query: String) {
        let attributedString = NSMutableAttributedString(string: country,
                                                         letterSpacing: 0.8,
                                                         font: .apercuLight(ofSize: 16),
                                                         textColor: .white,
                                                         alignment: .left)
        attributedString.setColorForText(query, with: .aquaMarine)
        countryLabel.attributedText = attributedString
        accessoryType = .none
    }
}
