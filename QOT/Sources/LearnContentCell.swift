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

    fileprivate lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.40)
        label.font = UIFont.simpleFont(ofSize: 16)
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.simpleFont(ofSize: 16)
        label.minimumScaleFactor = 0.1
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
        return label
    }()
    
    fileprivate lazy var videoDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.40)
        label.font = UIFont.bentonBookFont(ofSize: 11)
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

    func configure(with content: LearnContentCollection, index: Int) {
        indexLabel.addCharactersSpacing(spacing: 1, text: "#\(String(format: "%02d", index))")
        titleLabel.addCharactersSpacing(spacing: 1, text: content.title, uppercased: true)
        let min = String(content.minutesRequired)
        videoDurationLabel.addCharactersSpacing(spacing: 1, text: R.string.localized.learnContentListViewMinutesLabel(min))
        let bubbleSelected = content.viewed
        if !bubbleSelected {
            imageView.image = R.image.strategyback()
        } else {
            imageView.image = R.image.strategyvisited()
            titleLabel.textColor = UIColor.white.withAlphaComponent(0.40)
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
        textContainerView.topAnchor == contentView.topAnchor +  35
        textContainerView.widthAnchor == contentView.widthAnchor - 40

        indexLabel.topAnchor == textContainerView.topAnchor
        indexLabel.horizontalAnchors == textContainerView.horizontalAnchors
        indexLabel.bottomAnchor == titleLabel.topAnchor

        titleLabel.topAnchor == indexLabel.bottomAnchor
        titleLabel.horizontalAnchors == textContainerView.horizontalAnchors
        titleLabel.bottomAnchor == videoDurationLabel.topAnchor - 8
        
        videoDurationLabel.horizontalAnchors == textContainerView.horizontalAnchors
        videoDurationLabel.bottomAnchor == textContainerView.bottomAnchor - 30
    }
}
