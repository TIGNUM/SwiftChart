//
//  RequestDeviceSensorCollectionViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class RequestDeviceSensorCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        layer.cornerRadius = 8.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.white40.cgColor
        titleLabel.font = Font.DPText
        titleLabel.textColor = .white40

        drawImage()
    }

    private func drawImage() {
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

    func setup(title: String) {
        titleLabel.addCharactersSpacing(spacing: 1, text: title)
    }
}
