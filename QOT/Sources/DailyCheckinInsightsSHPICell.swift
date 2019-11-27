//
//  DailyCheckinInsightsSHPICell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsSHPICell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var shpiQuestionLabel: UILabel!
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
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(barsStackView)

    }
    func configure(with: DailyCheck2SHPIModel?) {
        guard let model = with else { return }
        updateView(text: model.shpiContent, rating: model.shpiRating ?? 0, shpiQuestion: model.shpiQuestion)
        skeletonManager.hide()
        baseHeaderView?.configure(title: model.title,
                                  subtitle: model.shpiQuestion)
        ThemeText.dailyBriefTitle.apply(model.title, to: baseHeaderView?.titleLabel)
        ThemeText.searchTopic.apply(model.shpiQuestion, to: baseHeaderView?.subtitleTextView)
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
    }
}

private extension DailyCheckinInsightsSHPICell {
    func updateView(text: String?, rating: Int, shpiQuestion: String?) {
        baseHeaderView?.subtitleTextView.text = text
        ThemeText.shpiQuestion.apply(shpiQuestion, to: shpiQuestionLabel)
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
