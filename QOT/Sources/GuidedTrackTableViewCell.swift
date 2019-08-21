//
//  GuidedTrackTableCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class GuidedTrackTableViewCell: UITableViewCell, UITableViewDelegate, Dequeueable, UITableViewDataSource {

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var showSteps = false

    var guidedTrackList = [GuideTrackModelItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerDequeueable(GuidedTrackSectionCell.self)
        tableView.registerDequeueable(GuidedTrackRowCell.self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewHeight), name: .displayGuidedTrackCells, object: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSteps ? guidedTrackList.count : 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = guidedTrackList[indexPath.row]
        switch item.type {
        case GuidedTrackItemType.SECTION:
            let cell: GuidedTrackSectionCell = tableView.dequeueCell(for: indexPath)
            let model = item as? GuidedTrackSectionViewModel
            cell.configure(with: model)
            return cell
        case GuidedTrackItemType.ROW:
            let cell: GuidedTrackRowCell = tableView.dequeueCell(for: indexPath)
            let model = item as? GuidedTrackRowViewModel
            cell.configure(with: model)
            return cell
        }
    }

    func configure(with: GuidedTrackViewModel?) {
        if let list = with?.guidedTrackList, list.isEmpty == false {
            self.guidedTrackList.removeAll()
            self.guidedTrackList = list
            tableView.reloadData()
        }
    }

    @objc func updateTableViewHeight() {
        tableViewHeightConstraint.constant = showSteps ? 250 : CGFloat(guidedTrackList.count * 250)
    }
}
