//
//  LevelsChartView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/11/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LevelsChartView: UIView {

    struct Item {
        let color: UIColor
        let column: Int
        let row: Int
    }

    private var columnCount: Int = 0
    private var rowCount: Int = 0
    private var items = [Item]()

    private var gridView: GridView = GridView()
    private var itemsView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupHierarchy()
    }

    private func setupHierarchy() {
        addSubview(gridView)
        addSubview(itemsView)
    }

    func configure(items: [Item], columnCount: Int, rowCount: Int) {
        gridView.configure(columnCount: columnCount, rowCount: rowCount, seperatorHeight: 1, seperatorColor: .gray)
        self.items = items
        self.columnCount = columnCount
        self.rowCount = rowCount

        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gridView.frame = bounds
        itemsView.frame = bounds
        addLayers()
    }

    private func eventLayer(frame: CGRect, color: UIColor) -> CALayer {
        let layer = CALayer()
        layer.frame = frame
        let radius = min(frame.width, frame.height)
        layer.cornerRadius = radius / 2
        layer.backgroundColor = color.cgColor
        return layer
    }

    private func addLayers() {
        let columnWidth = bounds.width / CGFloat(columnCount)
        let rowHeight = bounds.height / CGFloat(rowCount)
        let padding = CGFloat(1.5)

        itemsView.layer.sublayers = items.enumerated().map { (_, item) in
            let itemX = ((CGFloat(item.column) * columnWidth)) + padding
            let itemY = (CGFloat(item.row) * rowHeight) + padding
            let width = columnWidth - padding * 2
            let height = rowHeight - padding * 2
            let frame = CGRect(x: itemX, y: itemY, width: width, height: height)
            
            return eventLayer(frame: frame, color: item.color)
        }
    }
}
