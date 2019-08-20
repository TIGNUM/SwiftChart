//
//  MyQotMainCollectionViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyQotMainCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(title: String, subtitle: String) {
        titleLabel.text = title.uppercased()
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = UIColor.sand
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.sand40.cgColor
        layer.cornerRadius = 15
        layer.borderWidth = 1
    }
}
