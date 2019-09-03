//
//  MyPeakPerformanceTableCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPeakPerformanceTableCell: BaseDailyBriefCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    var peakPerformanceList = [MyPerformanceModelItem]()
    var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        tableView.registerDequeueable(MyPeakPerformanceRowCell.self)
        tableView.registerDequeueable(MyPeakPerformanceSectionCell.self)
        tableView.registerDequeueable(MyPeakPerformanceTitleCell.self)
        tableView.corner(radius: Layout.cornerRadius08)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peakPerformanceList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = peakPerformanceList[indexPath.row]
        print(item.type)
        switch item.type {
        case .SECTION:
            let cell: MyPeakPerformanceSectionCell = tableView.dequeueCell(for: indexPath)
            let model = item as? MyPeakPerformanceSectionModel
            cell.configure(with: model)
            return cell
        case .ROW:
            let cell: MyPeakPerformanceRowCell = tableView.dequeueCell(for: indexPath)
            let model = item as? MyPeakPerformanceRowModel
            cell.configure(with: model)
            return cell
        case .TITLE:
            let cell: MyPeakPerformanceTitleCell = tableView.dequeueCell(for: indexPath)
            let model = item as? MypeakperformanceTitleModel
            cell.configure(with: model)
            return cell
        }
    }

    func configure(with: MyPeakPerformanceCellViewModel?, tableViewHeight: CGFloat) {
        if let list = with?.peakPerformanceSectionList, list.isEmpty == false {
            self.peakPerformanceList = list
            tableViewHeightConstraint.constant = tableViewHeight
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = peakPerformanceList[indexPath.row]
        if item.type == .ROW {
            let item = item as? MyPeakPerformanceRowModel
            delegate?.openPreparation((item?.qdmUserPreparation!)!)
        }
    }
}
