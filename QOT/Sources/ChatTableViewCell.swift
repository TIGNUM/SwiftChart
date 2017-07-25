//
//  ChatTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell, Dequeueable {
    
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingBubbleLeft: UIView!
    @IBOutlet weak var loadingBubbleMiddle: UIView!
    @IBOutlet weak var loadingBubbleRight: UIView!
    
    var isTyping: Bool = false {
        didSet {
            if isTyping {
                animateBubbles()
                iconImageView.isHidden = true
                bubbleView.isHidden = true
                loadingView.isHidden = false
            } else {
                iconImageView.isHidden = false
                bubbleView.isHidden = false
                loadingView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        iconImageView.layer.cornerRadius = 12
        iconImageView.layer.masksToBounds = true

        bubbleView.layer.cornerRadius = 8
        bubbleView.layer.masksToBounds = true
        backgroundColor = .clear
        
        loadingView.layer.cornerRadius = 8
        loadingView.layer.masksToBounds = true
        
        loadingBubbleLeft.alpha = 0.2
        loadingBubbleMiddle.alpha = 0.2
        loadingBubbleRight.alpha = 0.2
        
        animateBubbles()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingBubbleLeft.layer.cornerRadius = loadingBubbleLeft.bounds.size.height * 0.5
        loadingBubbleMiddle.layer.cornerRadius = loadingBubbleMiddle.bounds.size.height * 0.5
        loadingBubbleRight.layer.cornerRadius = loadingBubbleRight.bounds.size.height * 0.5
    }

    func setup(showIcon: Bool) {
        iconImageView?.isHidden = showIcon == false 
    }

    // MARK: - private
    
    private func animateBubbles() {
        UIView.animateKeyframes(withDuration: 2.0, delay: 0.0, options: .repeat, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.16, animations: {
                self.loadingBubbleLeft.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.16, relativeDuration: 0.32, animations: {
                self.loadingBubbleLeft.alpha = 0.2
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.16, animations: {
                self.loadingBubbleMiddle.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.32, animations: {
                self.loadingBubbleMiddle.alpha = 0.2
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.16, animations: {
                self.loadingBubbleRight.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.83, relativeDuration: 0.32, animations: {
                self.loadingBubbleRight.alpha = 0.2
            })
        }, completion: nil)
    }
}
