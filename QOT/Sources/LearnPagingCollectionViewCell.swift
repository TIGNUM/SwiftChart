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
        categoryTitleLabel.text = title.replacingOccurrences(of: " ", with: "\n").uppercased()
        categoryTitleLabel.numberOfLines = 2    
        categoryTitleLabel.textAlignment = .center
        categoryTitleLabel.font = Font.H5SecondaryHeadline
        categoryTitleLabel.textColor = shouldHighlight == true ? .white : Color.whiteMedium
    }
}
