//
//  GraphTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol TBVDataGraphTableViewCellProtocol: class {
    func didSelect(date: Date)
}

final class TBVDataGraphTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var collectionView: TBVDataGraphCollectionView!
    weak var delegate: TBVDataGraphTableViewCellProtocol?

    var averages = [Date: Double]()
    var days = [Date]()
    var config: TBVGraph.BarGraphConfig = .tbvDataConfig()
    var range: TBVGraph.Range = .defaultRange()

    func setup(averages: [Date: Double], days: [Date], config: TBVGraph.BarGraphConfig, range: TBVGraph.Range) {
        self.averages = averages
        self.days = days
        self.config = config
        self.range = range

        collectionView.collectionDelegate = self
        collectionView.reloadData()
    }
}

extension TBVDataGraphTableViewCell: TBVDataGraphCollectionViewProtocol {
    func didSelect(date: Date) {
        delegate?.didSelect(date: date)
    }
}
