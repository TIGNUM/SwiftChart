//
//  SearchFieldTableCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class SearchTableCell: UITableViewCell, Dequeueable {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.font = UIFont.simpleFont(ofSize: 20)
        label.textColor = .white
        return label
    }()

    private lazy var mediaLabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.font = UIFont.bentonBookFont(ofSize: 8)
        label.textColor = .white
        return label
    }()

    private lazy var durationlabel: UILabel = {
        let label = UILabel()
        label.frame = .zero
        label.font = UIFont.bentonBookFont(ofSize: 8)
        label.textColor = .white
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLayout()
    }

    func setUp(title: String, media: String, duration: String) {
        titleLabel.text = title
        mediaLabel.text = media
        durationlabel.text = duration
        selectionStyle = .none
    }
}

private extension SearchTableCell {

    func setUpHierarchy() {
        addSubview(titleLabel)
        addSubview(mediaLabel)
        addSubview(durationlabel)
    }

    func setUpLayout() {
        titleLabel.topAnchor == topAnchor
        titleLabel.horizontalAnchors == horizontalAnchors
        titleLabel.heightAnchor == 36

        mediaLabel.topAnchor == titleLabel.bottomAnchor
        mediaLabel.leftAnchor == leftAnchor
        mediaLabel.bottomAnchor == bottomAnchor
        mediaLabel.rightAnchor == rightAnchor + 260

        durationlabel.topAnchor == titleLabel.bottomAnchor
        durationlabel.leftAnchor == leftAnchor + 60
        durationlabel.rightAnchor == rightAnchor
        durationlabel.bottomAnchor == bottomAnchor
        
        layoutIfNeeded()
    }
}
