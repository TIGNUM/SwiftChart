//
//  EventGraphView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/3/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class EventGraphView: UIView {

    struct Item {
        let start: CGFloat
        let end: CGFloat
        let color: UIColor
    }

    struct Column {
        let items: [Item]
        let width: CGFloat
    }

    var columns: [Column] = [] {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        displayLayers()
    }

    private func layersForColumn(_ column: Column, centerX: CGFloat) -> [CALayer] {
        let adjustedWidth = column.width * bounds.width
        let x = centerX - (adjustedWidth / 2)

        return column.items.map { layerForItem($0, x: x, width: adjustedWidth) }
    }

    private func layerForItem(_ item: Item, x: CGFloat, width: CGFloat) -> CALayer {
        let y = bounds.height * item.start
        let height = bounds.height * (item.end - item.start)
        let frame = CGRect(x: x, y: y, width: width, height: height).integral
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: width).cgPath
        layer.fillColor = item.color.cgColor
        layer.addGlowEffect(color: .white)
        return layer
    }

    private func displayLayers() {
        guard columns.count > 0 else {
            return
        }
            let columnWidth = bounds.width / CGFloat(columns.count)
            self.layer.sublayers = columns.enumerated().map { (index, column) -> [CALayer] in
                let x = (CGFloat(index) * columnWidth) + (columnWidth / 2)
                return layersForColumn(column, centerX: x)
                }.flatMap { $0
        }
    }
}
