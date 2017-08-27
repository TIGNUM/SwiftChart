//
//  IntensityAverageView.swift
//  QOT
//
//  Created by tignum on 6/21/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class IntensityAverageView: UIView {

    struct Item {
        let start: CGFloat
        let end: CGFloat
        let color: Color
    }

    struct Column {
        let items: [Item]
        let eventWidth: CGFloat
    }

    enum Color {
        case criticalColor
        case normalColor
    }

    var columns: [Column] = [] {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        displayLayers()
    }

    private func layersForColumn(_ column: Column, centerX: CGFloat) -> [CALayer] {
        let width: CGFloat =  CGFloat(column.eventWidth)
        let x = centerX - width / 2

        return column.items.map { layerForItem($0, x: x, width: width)}
    }

    private func layerForItem(_ item: Item, x: CGFloat, width: CGFloat) -> CALayer {
        let y = bounds.height * item.start
        let height = bounds.height * (item.end - item.start)
        let frame = CGRect(x: x, y: y, width: width, height: height).integral
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: width / 2).cgPath
        var borderColor = UIColor.white.cgColor
        switch item.color {
        case .criticalColor:
            layer.fillColor = UIColor.cherryRedTwo30.cgColor
            borderColor = UIColor.cherryRed.cgColor
        case .normalColor:
            layer.fillColor = UIColor.white8.cgColor
        }
        layer.strokeColor = borderColor

        return layer
    }

    private func displayLayers() {
        guard columns.count > 0 else {
            return
        }

        let columnWidth = bounds.width / CGFloat(columns.count)
        layer.sublayers = columns.enumerated().map { (index, column) -> [CALayer] in
            let x = (CGFloat(index) * columnWidth) + columnWidth / 2.0
            return layersForColumn(column, centerX: x)
            }.flatMap { $0
        }
    }
}
