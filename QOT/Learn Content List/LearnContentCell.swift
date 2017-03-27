//
//  LearnContentCell.swift
//  QOT
//
//  Created by tignum on 3/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class LearnContentCell: UICollectionViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
        return label
    }()
    
    fileprivate lazy var videoDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 8)
        return label
    }()
    
    fileprivate lazy var textContainerView: UIView = {
        let view = UIView()
        view.addSubview(self.titleLabel)
        view.addSubview(self.videoDurationLabel)
        return view
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = view.frame.width / 2
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func configure(with content: LearnContent) {
        
        titleLabel.text = content.title
        videoDurationLabel.text = "\(content.minutesRequired)MIN" // FIXME: Localization
        let bubbleSelected = content.viewed
        if bubbleSelected != true {
            imageView.image = R.image.bubblesWithCorner()
        } else {
            imageView.image = R.image.bubblesWithGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(textContainerView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.width / 2
        imageView.frame = contentView.frame
        contentView.addSubview(imageView)
    }
}

private extension LearnContentCell {
    func setupLayout() {
        textContainerView.horizontalAnchors == contentView.horizontalAnchors + 20
        textContainerView.topAnchor == contentView.topAnchor +  50
        textContainerView.widthAnchor == contentView.widthAnchor - 40
        
        titleLabel.topAnchor == textContainerView.topAnchor
        titleLabel.horizontalAnchors == textContainerView.horizontalAnchors
        titleLabel.bottomAnchor == videoDurationLabel.topAnchor
        
        videoDurationLabel.horizontalAnchors == textContainerView.horizontalAnchors
        videoDurationLabel.bottomAnchor == textContainerView.bottomAnchor - 30
    }
}
