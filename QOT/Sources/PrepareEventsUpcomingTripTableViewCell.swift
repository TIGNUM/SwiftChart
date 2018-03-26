//
//  PrepareEventsUpcomingTripTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 13.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import EventKit

class PrepareEventsUpcomingTripTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(event: EKEvent) {
        let date = event.startDate.eventStringDate(endDate: event.endDate)
        titleLabel.addCharactersSpacing(spacing: 1, text: event.title, uppercased: true)
        dateLabel.addCharactersSpacing(spacing: 2, text: date, uppercased: true)
    }
}
