//
//  SigningInfoCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 13.06.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

extension SigningInfoCollectionViewCell {
    func configure(title: String?, body: String?) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}
