//
//  DailyCheckinInsightsPeakPerformanceCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsPeakPerformanceCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var peakEventsLabel: UILabel!
    @IBOutlet private weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with: DailyCheckIn2PeakPerformanceModel?) {
        peakEventsLabel.text = with?.intro
    }

    @IBAction func preparations(_ sender: Any) {
    }

}
