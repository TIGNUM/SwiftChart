//
//  GraphTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol TBVDataGraphTableViewCellProtocol: class {
    func didSelect(date: Date?)
}

final class TBVDataGraphTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var collectionView: TBVDataGraphCollectionView!
    weak var delegate: TBVDataGraphTableViewCellProtocol?

    var configOfGraph: TBVGraph.BarGraphConfig = .tbvDataConfig()
    var itemsOfGraph: [TBVGraph.Rating] = []
    var rangeOfGraph: TBVGraph.Range = .defaultRange()

    func setup(items: [TBVGraph.Rating]?, config: TBVGraph.BarGraphConfig, range: TBVGraph.Range) {
        configOfGraph = config
        itemsOfGraph = items ?? []
        rangeOfGraph = range
        collectionView.collectionDelegate = self
        collectionView.reloadData()
    }
}
extension TBVDataGraphTableViewCell: TBVDataGraphCollectionViewProtocol {
    func didSelect(date: Date?) {
        delegate?.didSelect(date: date)
    }

    func range() -> TBVGraph.Range {
        return rangeOfGraph
    }

    func ratings() -> [TBVGraph.Rating] {
        return itemsOfGraph
    }

    func config() -> TBVGraph.BarGraphConfig {
        return configOfGraph
    }
}
