//
//  LearnPagingCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 29.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LearnPagingCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var categoryTitleLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    func configure(title: String, shouldHighlight: Bool) {
        categoryTitleLabel.text = title        
        categoryTitleLabel.font = shouldHighlight == true ? Font.H5SecondaryHeadline : Font.H7Title
        categoryTitleLabel.textColor = shouldHighlight == true ? .white : Color.whiteMedium
    }
}
