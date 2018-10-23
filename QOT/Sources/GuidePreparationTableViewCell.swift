//
//  GuidePreparationTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 17.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

class GuidePreparationTableViewCell: UITableViewCell, Dequeueable {
    
    // MARK: - Properties
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var actionLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        typeLabel.textColor = .gray
        actionLabel.font = .apercuBold(ofSize: 14)
        statusView.corner(radius: statusView.bounds.width / 2)
        containerView.corner(radius: Layout.CornerRadius.eight.rawValue)
    }
    
    // MARK: - Cell configruation
    
    func configure(title: String, body: String, status: Guide.Item.Status) {
        bodyLabel.text = body
        titleLabel.text = title.uppercased()
        statusView.backgroundColor = status.statusViewColor
    }
}
