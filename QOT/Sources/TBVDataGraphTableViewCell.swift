//
//  GraphTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol TBVDataGraphProtocol: class {
    func didSelect(date: Date)
}

final class TBVDataGraphTableViewCell: UITableViewCell, Dequeueable, TBVDataGraphProtocol {

    @IBOutlet weak var collectionView: TBVDataGraphCollectionView!
    weak var delegate: TBVDataGraphProtocol?

    func setup(report: ToBeVisionReport?, config: TBVGraph.BarGraphConfig, range: TBVGraph.Range) {
        collectionView.tbvReport = report
        collectionView.config = config
        collectionView.range = range
        collectionView.graphDelegate = self
        collectionView.reloadData()
    }

    func didSelect(date: Date) {
        delegate?.didSelect(date: date)
    }
}
