//
//  AverageGraphView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/10/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class AverageGraphView: UIView {

    private static let minKnobSize: CGFloat = 20
    private static let maxKnobSize: CGFloat = 40
    private var position: CGFloat = 0
    fileprivate lazy var topLine: CALayer = CALayer()
    fileprivate lazy var rightLine: CALayer = CALayer()

    fileprivate lazy var squareLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.20).cgColor
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()

    fileprivate lazy var knobLayer: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 3
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpHierachy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUpHierachy()
    }

    func configure(position: CGFloat, knobColor: UIColor, lineColor: UIColor) {
        self.position = max(min(1, position), 0)

        knobLayer.backgroundColor = knobColor.cgColor
        topLine.backgroundColor = lineColor.cgColor
        rightLine.backgroundColor = lineColor.cgColor

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutKnob()
        layoutSquare()
    }

    private func setUpHierachy() {
        layer.sublayers = [squareLayer, topLine, rightLine, knobLayer]
    }

    private func layoutKnob() {
        let size: CGFloat = AverageGraphView.minKnobSize + ((AverageGraphView.maxKnobSize - AverageGraphView.minKnobSize) * position)
        let length = min(bounds.width, bounds.height)
        let difference: CGFloat = position * (length - size)
        let x: CGFloat = difference
        let y: CGFloat = length - difference
        knobLayer.frame = CGRect(x: x, y: y - size, width: size, height: size)
    }

    private func layoutSquare() {
        let width: CGFloat = knobLayer.frame.midX
        let y = min(bounds.maxY, bounds.maxX)
        squareLayer.frame = CGRect(x: 0, y: y - width, width: width, height: width)
        topLine.frame = CGRect(x: 0, y: y - width, width: width, height: 1)
        rightLine.frame = CGRect(x: squareLayer.frame.maxX, y: y - width, width: 1, height: width)
    }
}
