//
//  GuidedTrackTableCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

//TODO after further testing please remove this class.
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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSteps ? guidedTrackList.count : 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func configure(with: GuidedTrackViewModel?) {
    }

    @objc func updateTableViewHeight() {
        tableViewHeightConstraint.constant = showSteps ? 250 : CGFloat(guidedTrackList.count * 250)
    }
}
