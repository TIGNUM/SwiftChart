//
//  DailyCheckinInsightsSHPICell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsSHPICell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var SHPIText: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var barsTitleLabel: UILabel!
    @IBOutlet weak var barsStackView: UIStackView!

    @IBOutlet private var bars: [UIView]?
    @IBOutlet private var labels: [UILabel]?
    @IBOutlet private var heights: [NSLayoutConstraint]?

    override func awakeFromNib() {
        bars?.forEach {(bar) in
            bar.frame = CGRect(x: 0, y: 0, width: 1, height: 35)
        }
        super.awakeFromNib()
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(SHPIText)
        skeletonManager.addOtherView(barsStackView)

    }
//TO DO: title label and adviceLabel texts should not be hardcoded in the xib file
    func configure(with: DailyCheck2SHPIModel?) {
        guard let model = with else { return }
        updateView(text: model.shpiContent, rating: model.shpiRating ?? 0)
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply(model.title, to: bucketTitle)
    }
}

private extension DailyCheckinInsightsSHPICell {
    func updateView(text: String?, rating: Int) {
        SHPIText.text = text
        let selectedIndex = max(0, rating - 1)
        for index in 0...9 {
            var barHeight: CGFloat = 32.0
            var fontSize: CGFloat = 12.0
            var color: UIColor = .white40
            if index == selectedIndex {
                barHeight = 56.0
                fontSize = 16.0
                color = .white
            }
            if labels?.count ?? 0 > index {
                labels?[index].font = labels?[index].font.withSize(fontSize)
                labels?[index].textColor = color
            }

            if heights?.count ?? 0 > index {
                heights?[index].constant = barHeight
            }

            if bars?.count ?? 0 > index {
                bars?[index].backgroundColor = color
                bars?[index].setNeedsUpdateConstraints()
            }
        }
    }
}
