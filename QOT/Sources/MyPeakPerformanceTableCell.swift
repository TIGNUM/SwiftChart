//
//  MyPeakPerformanceTableCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPeakPerformanceTableCell: UITableViewCell, UITableViewDelegate, Dequeueable, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    var peakPerformanceList = [MyPerformanceModelItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        let sectionNib = UINib.init(nibName: "MyPeakPerformanceSectionCell", bundle: nil)
        tableView.register(sectionNib, forCellReuseIdentifier: "MyPeakPerformanceSectionCell")
        let rowNib = UINib.init(nibName: "MyPeakPerformanceRowCell", bundle: nil)
        tableView.register(rowNib, forCellReuseIdentifier: "MyPeakPerformanceRowCell")
        let titleNib = UINib.init(nibName: "MyPeakPerformanceTitleCell", bundle: nil)
        tableView.register(titleNib, forCellReuseIdentifier: "MyPeakPerformanceTitleCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peakPerformanceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = peakPerformanceList[indexPath.row]
        print(item.type)
        switch item.type {
        case .SECTION:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyPeakPerformanceSectionCell",
                                                        for: indexPath) as? MyPeakPerformanceSectionCell {
                cell.configure()
                return cell
            }
        case .ROW:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyPeakPerformanceRowCell",
                                                        for: indexPath) as? MyPeakPerformanceRowCell {
                cell.configure()
                return cell
            }
        case .TITLE:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MyPeakPerformanceTitleCell",
                                                        for: indexPath) as? MyPeakPerformanceTitleCell {
                cell.configure()
                return cell
            }
        }
        return UITableViewCell()
    }

    func configure(with: MyPeakPerformanceCellViewModel?) {
        if let list = with?.peakPerformanceSectionList, list.isEmpty == false {
            self.peakPerformanceList = list
            tableView.reloadData()
        }
    }

}
