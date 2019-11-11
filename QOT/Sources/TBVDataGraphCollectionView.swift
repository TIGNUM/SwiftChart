//
//  TBVDataGraphCollectionView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol TBVDataGraphCollectionViewProtocol: class {
    var range: TBVGraph.Range { get }
    var ratings: [TBVGraph.Rating] { get }
    var config: TBVGraph.BarGraphConfig { get }
    func didSelect(date: Date)
}

class TBVDataGraphCollectionView: UICollectionView {

    enum GraphBarTypes: Int {
        case range = 0
        case first = 1
        case firstCompanion = 2
        case second = 4
        case secondCompanion = 5
        case third = 7
        case thirdCompanion = 8
        case future = 10
    }

    weak var collectionDelegate: TBVDataGraphCollectionViewProtocol?
    let numberOfGraphs = 11

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        registerDequeueable(TBVDataGraphBarViewCell.self)
        registerDequeueable(TBVGraphBarRangeCell.self)
        registerDequeueable(TBVDataGraphBarNextDurationViewCell.self)
        delegate = self
        dataSource = self
    }

    private func durationCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TBVDataGraphBarNextDurationViewCell = collectionView.dequeueCell(for: indexPath)
        cell.duration = ""
        return cell
    }

    private func graphCell(with rating: TBVGraph.Rating = .defaultRating(),
                           for collectionView: UICollectionView,
                           at indexPath: IndexPath) -> UICollectionViewCell {
        guard let delegate = collectionDelegate else {
            fatalError("Collection delegate not present")
        }
        let cell: TBVDataGraphBarViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setup(with: delegate.config,
                   isSelected: rating.isSelected,
                   ratingTime: rating.ratingTime,
                   rating: CGFloat(rating.rating),
                   range: delegate.range())
        return cell
    }

    private func rangeCell(with range: TBVGraph.Range = .defaultRange(),
                           for collectionView: UICollectionView,
                           at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TBVGraphBarRangeCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: range)
        return cell
    }
}

extension TBVDataGraphCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfGraphs
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        return CGSize(width: screenWidth/CGFloat(numberOfGraphs), height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = collectionDelegate else {
            fatalError("Collection delegate not present")
        }
        guard let barType = GraphBarTypes(rawValue: indexPath.item) else {
            return
        }
        switch barType {
        case .first, .firstCompanion:
            let rating = delegate.ratings()[0]
            delegate.didSelect(date: rating.ratingTime)
        case .second, .secondCompanion:
            if delegate.ratings().count > 1 {
                let rating = delegate.ratings()[1]
                delegate.didSelect(date: rating.ratingTime)
            }
        case .third, .thirdCompanion:
            if delegate.ratings().count > 2 {
                let rating = delegate.ratings()[2]
                delegate.didSelect(date: rating.ratingTime)
            }
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getCell(at: indexPath, for: collectionView)
    }

    func getCell(at indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionViewCell {
        guard let delegate = collectionDelegate else {
            fatalError("Collection delegate not present")
        }

        guard let barType = GraphBarTypes(rawValue: indexPath.item) else {
            return graphCell(for: collectionView, at: indexPath)
        }

        switch barType {
        case .range:
            return rangeCell(for: collectionView, at: indexPath)
        case .first:
            let rating = delegate.ratings()[0]
            return graphCell(with: rating, for: collectionView, at: indexPath)
        case .second:
            if delegate.ratings().count > 1 {
                let rating = delegate.ratings()[1]
                return graphCell(with: rating, for: collectionView, at: indexPath)
            } else {
                return durationCell(for: collectionView, at: indexPath)
            }
        case .third:
            if delegate.ratings().count > 2 {
                let rating = delegate.ratings()[2]
                return graphCell(with: rating, for: collectionView, at: indexPath)
            } else if delegate.ratings().count == 2 {
                return durationCell(for: collectionView, at: indexPath)
            } else {
                return graphCell(for: collectionView, at: indexPath)
            }
        case .future:
            if delegate.ratings().count > 2 {
                return durationCell(for: collectionView, at: indexPath)
            } else {
                return graphCell(for: collectionView, at: indexPath)
            }
        default:
            return graphCell(for: collectionView, at: indexPath)
        }
    }
}
