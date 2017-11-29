//
//  SearchFieldCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class SearchCollectionCell: UICollectionViewCell, Dequeueable {

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addSubview(titleLabel)
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bentonBookFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()

    func setUp(title: String) {
        titleLabel.text = title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

extension SearchCollectionCell {

    func setupLayout() {
        titleLabel.horizontalAnchors == contentView.horizontalAnchors
        titleLabel.verticalAnchors == contentView.verticalAnchors

        layoutIfNeeded()
    }
}
