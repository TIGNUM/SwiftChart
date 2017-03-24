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
        label.text = "i am loading"
        //label.backgroundColor = .green
        return label
    }()
    
    fileprivate lazy var videoDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 8)
        label.text = "hello"
        //label.backgroundColor = .orange
        return label
    }()
    
    fileprivate lazy var textContainerView: UIView = {
        let view = UIView()
        view.addSubview(self.titleLabel)
        view.addSubview(self.videoDurationLabel)
        return view
    }()
    
    func configure(with content: LearnContent) {
        
        titleLabel.text = content.title
        videoDurationLabel.text = "\(content.minutesRequired)MIN" // FIXME: Localization
        
        let bubbleSelected = content.viewed
        if bubbleSelected != true {
            
        } else {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.clear
        contentView.layer.borderWidth = 1.0
        contentView.addSubview(textContainerView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.width / 2
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
