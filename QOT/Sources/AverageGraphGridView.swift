//
//  AverageGraphGridView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/10/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class AverageGraphGridView: UIView {

    fileprivate lazy var gridView: GridView = GridView()
    fileprivate lazy var averageGraphView: AverageGraphView = AverageGraphView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpHierarchy()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUpHierarchy()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gridView.frame = bounds
        averageGraphView.frame = bounds
    }

    func configure(columns: [EventGraphView.Column], value: CGFloat, knobColor: UIColor, lineColor: UIColor) {
        gridView.configure(columnCount: columns.count, rowCount: columns.count, seperatorHeight: 1, seperatorColor: .gray)
        averageGraphView.configure(position: value, knobColor: knobColor, lineColor: lineColor)
    }

    private func setUpHierarchy() {
        addSubview(gridView)
        addSubview(averageGraphView)
    }
}
