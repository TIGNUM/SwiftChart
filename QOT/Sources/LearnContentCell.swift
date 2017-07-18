//
//  LearnContentCell.swift
//  QOT
//
//  Created by tignum on 3/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class LearnContentCell: UICollectionViewCell, Dequeueable {

    fileprivate lazy var indexLabel = UILabel()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var videoDurationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate lazy var textContainerView: UIView = {
        let view = UIView()
        view.addSubview(self.indexLabel)
        view.addSubview(self.titleLabel)
        view.addSubview(self.videoDurationLabel)

        return view
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit

        return view
    }()

    func configure(with content: ContentCollection, index: Int) {
        let min = String(content.minutesRequired)
        let attributedIndex = Style.headlineSmall("#\(String(format: "%02d", index + 1))", .white50).attributedString()
        let attributedTitle = NSMutableAttributedString(
            string: content.title.uppercased(),
            letterSpacing: 1,
            font: Font.H5SecondaryHeadline,
            textColor: .white,
            lineBreakMode: .byTruncatingTail
        )
        let attributedDuration = NSMutableAttributedString(
            string: R.string.localized.learnContentListViewMinutesLabel(min),
            letterSpacing: 2,
            font: Font.H7Title,
            textColor: .white40
        )
        indexLabel.attributedText = attributedIndex
        titleLabel.attributedText = attributedTitle
        videoDurationLabel.attributedText = attributedDuration
        let bubbleSelected = content.viewed
        if !bubbleSelected {
            imageView.image = R.image.strategyback()
        } else {
            imageView.image = R.image.strategyvisited()
            titleLabel.textColor = .white40
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(textContainerView)
        contentView.addSubview(imageView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.insideCircle(frame: bounds)
    }
}

private extension LearnContentCell {

    func setupLayout() {
        imageView.edgeAnchors == contentView.edgeAnchors
        textContainerView.horizontalAnchors == contentView.horizontalAnchors + 20
        textContainerView.topAnchor == contentView.topAnchor + 36
        textContainerView.widthAnchor == contentView.widthAnchor - 40

        indexLabel.topAnchor == textContainerView.topAnchor
        indexLabel.horizontalAnchors == textContainerView.horizontalAnchors
        indexLabel.bottomAnchor == titleLabel.topAnchor

        titleLabel.topAnchor == indexLabel.bottomAnchor
        titleLabel.horizontalAnchors == textContainerView.horizontalAnchors
        titleLabel.bottomAnchor == videoDurationLabel.topAnchor
        
        videoDurationLabel.horizontalAnchors == textContainerView.horizontalAnchors
        videoDurationLabel.bottomAnchor == textContainerView.bottomAnchor
        videoDurationLabel.heightAnchor == 16
        textContainerView.layoutIfNeeded()
    }
}
