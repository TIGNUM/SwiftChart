//
//  SittingMovementChartView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/9/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SittingMovementChartView: UIView {

    fileprivate lazy var gridView: GridView = {
        let view = GridView()
        return view
    }()

    fileprivate lazy var eventView: EventGraphView = {
        let view = EventGraphView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadSubViews()
    }

    func configure(columns: [EventGraphView.Column]) {
        eventView.columns = columns
        gridView.configure(columnCount: columns.count, rowCount: 1, seperatorHeight: 1, seperatorColor: .gray)
    }

    private func setup() {
        addSubview(gridView)
        addSubview(eventView)
    }

    private func loadSubViews() {
        gridView.frame = bounds
        eventView.frame = bounds
    }
}
