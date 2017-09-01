//
//  LearnContentCell.swift
//  QOT
//
//  Created by tignum on 3/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LearnContentCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    fileprivate lazy var indexLabel = UILabel()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        return label
    }()
    
    fileprivate lazy var videoDurationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true

        return label
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit

        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(with content: ContentCollection, index: Int) {
        let min = String(content.minutesRequired)
        let attributedIndex = Style.headlineSmall((String(format: "#%02d", index + 1)), .white50).attributedString()
        let attributedTitle = NSMutableAttributedString(
            string: content.title.uppercased(),
            letterSpacing: 1,
            font: contentView.bounds.width < 150 ? Font.H7Tag : Font.H5SecondaryHeadline,
            textColor: .white,
            lineBreakMode: .byTruncatingTail
        )
        let attributedDuration = NSMutableAttributedString(
            string: R.string.localized.learnContentListViewMinutesLabel(min),
            letterSpacing: contentView.bounds.width < 150 ? 1.3 : 2,
            font: contentView.bounds.width < 150 ? UIFont.bentonBookFont(ofSize: 10) : Font.H7Title,
            textColor: .white40
        )
        indexLabel.attributedText = attributedIndex
        titleLabel.attributedText = attributedTitle
        videoDurationLabel.attributedText = attributedDuration

        if content.viewed == false {
            imageView.image = R.image.strategyback()
        } else {
            imageView.image = R.image.strategyvisited()
            titleLabel.textColor = .white40
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.insideCircle(frame: bounds)
    }
}

// MARK: - Private

private extension LearnContentCell {

    func setupLayout() {
        addAllSubviews()
        setAnchors()
        contentView.layoutIfNeeded()
    }

    private func setAnchors() {
        imageView.edgeAnchors == contentView.edgeAnchors
        titleLabel.centerYAnchor == contentView.centerYAnchor
        titleLabel.leadingAnchor == contentView.leadingAnchor + 18
        titleLabel.trailingAnchor == contentView.trailingAnchor - 4

        indexLabel.trailingAnchor == titleLabel.trailingAnchor
        indexLabel.leadingAnchor == titleLabel.leadingAnchor
        indexLabel.bottomAnchor == titleLabel.topAnchor

        videoDurationLabel.leadingAnchor == titleLabel.leadingAnchor
        videoDurationLabel.trailingAnchor == titleLabel.trailingAnchor
        videoDurationLabel.topAnchor == titleLabel.bottomAnchor + 4
        videoDurationLabel.heightAnchor == 14
    }

    private func addAllSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(indexLabel)
        contentView.addSubview(videoDurationLabel)
        contentView.addSubview(imageView)
    }
}
