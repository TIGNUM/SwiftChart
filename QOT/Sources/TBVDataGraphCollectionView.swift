//
//  TBVDataGraphCollectionView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class TBVDataGraphCollectionView: UICollectionView {

    weak var graphDelegate: TBVDataGraphProtocol?
    var config: TBVGraph.BarGraphConfig = .tbvDataConfig()
    var range: TBVGraph.Range = .defaultRange()
    var tbvReport: ToBeVisionReport?

    private var getAverage: [Date: Double] {
        return tbvReport?.report.averages ?? [:]
    }

    private var getDates: [Date] {
        return tbvReport?.report.days ?? []
    }

    private var getSelectedDate: Date? {
        return tbvReport?.selectedDate
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

private extension TBVDataGraphCollectionView {
    func setupView() {
        registerDequeueable(TBVDataGraphBarViewCell.self)
        registerDequeueable(TBVGraphBarRangeCell.self)
        registerDequeueable(TBVDataGraphBarNextDurationViewCell.self)
        delegate = self
        dataSource = self
    }

    func durationCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TBVDataGraphBarNextDurationViewCell = collectionView.dequeueCell(for: indexPath)
        cell.duration = ""
        return cell
    }

    func graphCell(_ average: [Date: Double] = [:],
                   _ index: Int = 0,
                   for collectionView: UICollectionView,
                   at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TBVDataGraphBarViewCell = collectionView.dequeueCell(for: indexPath)
        let date = Array(average.keys).at(index: index)
        let rating = CGFloat(Array(average.values).at(index: index) ?? 0)
        let selected = date == getSelectedDate

        cell.setup(with: config, isSelected: selected, ratingTime: date, rating: rating, range: range)
        return cell
    }

    func rangeCell(with range: TBVGraph.Range = .defaultRange(),
                   for collectionView: UICollectionView,
                   at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TBVGraphBarRangeCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(with: range)
        return cell
    }

    func getCell(at indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionViewCell {
        guard let barType = TBVGraph.BarTypes(rawValue: indexPath.item) else {
            return graphCell(for: collectionView, at: indexPath)
        }

        let averageDict = getAverage
        switch barType {
        case .range:
            return rangeCell(with: range, for: collectionView, at: indexPath)
        case .first:
            return graphCell(averageDict, barType.index, for: collectionView, at: indexPath)
        case .second:
            if averageDict.count > barType.index {
                return graphCell(averageDict, barType.index, for: collectionView, at: indexPath)
            }
            return durationCell(for: collectionView, at: indexPath)
        case .third:
            if averageDict.count > barType.index {
                return graphCell(averageDict, barType.index, for: collectionView, at: indexPath)
            } else if averageDict.count == barType.index {
                return durationCell(for: collectionView, at: indexPath)
            }
            return graphCell(for: collectionView, at: indexPath)
        case .future:
            if averageDict.count > barType.index {
                return durationCell(for: collectionView, at: indexPath)
            }
            return graphCell(for: collectionView, at: indexPath)
        default:
            return graphCell(for: collectionView, at: indexPath)
        }
    }
}

extension TBVDataGraphCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TBVGraph.BarTypes.numberOfGraphs
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        return CGSize(width: screenWidth/CGFloat(TBVGraph.BarTypes.numberOfGraphs), height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let barType = TBVGraph.BarTypes(rawValue: indexPath.item) {
            switch barType {
            case .first,
                 .firstCompanion,
                 .second,
                 .secondCompanion,
                 .third,
                 .thirdCompanion:

                if getDates.count > barType.index {
                    graphDelegate?.didSelect(date: getDates[barType.index])
                }
            default: return
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getCell(at: indexPath, for: collectionView)
    }
}
