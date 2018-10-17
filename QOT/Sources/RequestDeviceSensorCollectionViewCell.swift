//
//  RequestDeviceSensorCollectionViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class RequestDeviceSensorCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        corner(radius: Layout.CornerRadius.eight.rawValue)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white40.cgColor
        titleLabel.font = .DPText
        titleLabel.textColor = .white40
		titleLabel.textAlignment = .center
        drawImage()
    }

    func configure(title: String) {
        titleLabel.addCharactersSpacing(spacing: 1, text: title)
    }
}

// MARK: - Private

private extension RequestDeviceSensorCollectionViewCell {

    func drawImage() {
        containerView.backgroundColor = .clear
        let center = containerView.convert(containerView.center, from: self)
        let lineSemiLength = containerView.frame.height / 4
        let strokeColor = UIColor.white40
        containerView.drawSolidCircle(arcCenter: center,
                                      radius: containerView.frame.width / 2,
                                      lineWidth: 1,
                                      strokeColor: strokeColor)
        let horizontalFrom = CGPoint(x: center.x - lineSemiLength, y: center.y)
        let horizontalTo = CGPoint(x: center.x + lineSemiLength, y: center.y)
        let verticalFrom = CGPoint(x: center.x, y: center.y - lineSemiLength)
        let verticalTo = CGPoint(x: center.x, y: center.y + lineSemiLength)
        containerView.drawSolidLine(from: horizontalFrom,
                                    to: horizontalTo,
                                    lineWidth: 1,
                                    strokeColor: strokeColor)
        containerView.drawSolidLine(from: verticalFrom,
                                    to: verticalTo,
                                    lineWidth: 1,
                                    strokeColor: strokeColor)
    }
}
