//
//  TripsDashView.swift
//  QOT
//
//  Created by Type-IT on 12.05.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class TripsDashView: UIView {

    private var ownTableSize: TableSize?
    private var ownDays: [Day]?
    private var cellHeight: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        configure(tableSize: ownTableSize!, days: ownDays!, cellHeight: cellHeight)
    }

    func configure(tableSize: TableSize, days: [Day], cellHeight: CGFloat) {
        ownTableSize = tableSize
        ownDays = days
        self.cellHeight = cellHeight

        var jump: Int = 0
        for i in 0 ... tableSize.columns-1 {
            for k in 0 ... tableSize.rows-1 {
                let x = CGFloat(i * cellWidth(numberOfCollumns: tableSize.columns))
                let maxCellHeight = frame.size.height / CGFloat(tableSize.rows)
                let centerY = (CGFloat(k) * maxCellHeight) + (0.5 * maxCellHeight)
                let y = centerY - (0.5 * cellHeight)
                let width = CGFloat(cellWidth(numberOfCollumns: tableSize.columns))

                let cell = TripsDashCellView(frame: CGRect(x: x, y: y, width: width, height: cellHeight))
                cell.configure(day: days[jump])
                jump += 1

                self.addSubview(cell)
            }
        }
    }

    func cellHeight(numberOfRows: Int) -> Int {
        return Int(frame.size.height) / numberOfRows
    }

    func cellWidth(numberOfCollumns: Int) -> Int {
        return Int(frame.size.width) / numberOfCollumns
    }
}

struct TableSize {
    let rows: Int
    let columns: Int
}
