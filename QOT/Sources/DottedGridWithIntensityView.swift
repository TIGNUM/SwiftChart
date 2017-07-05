//
//  DottedGridWithIntensityView.swift
//  QOT
//
//  Created by tignum on 6/21/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class DottedGridWithIntensityView: UIView {

    private var layers = [CAShapeLayer]()

    var duration: Int = 0 {
        didSet {setNeedsLayout()}
    }

    func setup(duration: Int) {
        self.duration = duration
        drawDottedColumns()
    }

    private func drawDottedColumns() {
        if duration >= layers.count {
            layers = [CAShapeLayer]()
            for _ in 0..<duration {
                let layer = drawLines(start: .zero, end: .zero, color: .white60)
                layers.append(layer)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        displayLayers()
    }

    private  func drawLines(start: CGPoint, end: CGPoint, color: UIColor) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.lineWidth = 1.0
        line.lineDashPattern = [0.5, 10]
        line.strokeColor = color.cgColor
        return line
    }

   private func displayLayers() {
        guard layers.count > 0 else {
            return
        }

        if layers.count < duration {
            drawDottedColumns()
            displayLayers()
        } else {
            removeSubLayers()
            let columnWidth = bounds.width / CGFloat(duration)
            let adjustedCloumnWidth = bounds.width / CGFloat(duration - 2)
            for index in 0..<duration {
                let startX =  duration < 30 ? bounds.minX + (CGFloat(index) * adjustedCloumnWidth) : bounds.minX + (CGFloat(index) * columnWidth) + (columnWidth / 2)
                let startY = bounds.minY
                let start = CGPoint(x: startX, y: startY)
                let end = CGPoint(x: startX, y: bounds.height)
                let linePath = UIBezierPath()
                linePath.move(to: start)
                linePath.addLine(to: end)
                layers[index].path = linePath.cgPath
                self.layer.addSublayer(layers[index])
            }
        }
    }
}
