//
//  DailyCheckinInsightsSHPICell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsSHPICell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var SHPIText: UILabel!
    @IBOutlet private var bars: [UIView]?
    @IBOutlet private var labels: [UILabel]?
    @IBOutlet private var heights: [NSLayoutConstraint]?

    override func awakeFromNib() {
        bars?.forEach {(bar) in
            bar.frame = CGRect(x: 0, y: 0, width: 1, height: 35)
        }
        super.awakeFromNib()

    }

    func configure(with: DailyCheck2SHPIModel?) {
        updateView(text: with?.shpiContent, rating: with?.shpiRating ?? 0)
    }
}

private extension DailyCheckinInsightsSHPICell {
    func updateView(text: String?, rating: Int) {
        SHPIText.text = text
        let index = rating < 1 ? 0 : rating - 1
        labels?[index].font = labels?[index].font.withSize(32)
        bars?[index].frame = CGRect(x: bars?[index].frame.origin.x ?? 0, y: -5, width: 2, height: 55)
        heights?[index].constant = 35
    }
}
