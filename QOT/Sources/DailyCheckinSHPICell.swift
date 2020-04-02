//
//  DailyCheckinInsightsSHPICell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyCheckinSHPICell: BaseDailyBriefCell {

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var shpiContentLabel: UILabel!
    @IBOutlet weak var shpiQuestionLabel: UILabel!
    @IBOutlet weak var barsTitleLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel?
    @IBOutlet weak var maxLabel: UILabel?
    @IBOutlet weak var barsStackView: UIStackView!
    @IBOutlet private var bars: [UIView]?
    @IBOutlet private var labels: [UILabel]?
    @IBOutlet private var heights: [NSLayoutConstraint]?
    private lazy var baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)

    override func awakeFromNib() {
        super.awakeFromNib()
        resetChart()
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(barsStackView)
        ThemeText.dailyInsightsChartBarLabelUnselected.apply(minLabel?.text, to: minLabel)
        ThemeText.dailyInsightsChartBarLabelUnselected.apply(maxLabel?.text, to: maxLabel)
    }

    func configure(with: DailyCheck2SHPIModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        setupRatingChart(rating: model.shpiRating ?? 0)
        baseHeaderView?.configure(title: model.title, subtitle: nil)
        ThemeText.dailyBriefTitle.apply(model.title, to: baseHeaderView?.titleLabel)
        ThemeText.shpiQuestion.apply(model.shpiQuestion, to: shpiQuestionLabel)
        ThemeText.shpiContent.apply(model.shpiContent, to: shpiContentLabel)
        ThemeText.shpiSubtitle.apply(AppTextService.get(.daily_brief_section_daily_insights_shpi_title_rated_yourself).uppercased(), to: barsTitleLabel)
    }
}

private extension DailyCheckinSHPICell {
    func setupRatingChart(rating: Int) {
        resetChart()
        let selectedIndex = max(0, rating - 1)
        labels?.at(index: selectedIndex)?.font.withSize(16)
        labels?.at(index: selectedIndex)?.textColor = .sand
        heights?.at(index: selectedIndex)?.constant = 56
        bars?.at(index: selectedIndex)?.backgroundColor = .sand
        bars?.at(index: selectedIndex)?.setNeedsUpdateConstraints()
        minLabel?.text = AppTextService.get(.daily_brief_section_daily_insights_shpi_label_never)
        maxLabel?.text = AppTextService.get(.daily_brief_section_daily_insights_shpi_label_always)
        minLabel?.textColor = selectedIndex == 0 ? .sand : .sand40
        maxLabel?.textColor = selectedIndex + 1 == (labels?.count ?? 0) ? .sand : .sand40
    }

    func resetChart() {
        bars?.forEach { ThemeView.dailyInsightsChartBarUnselected.apply($0) }
        labels?.forEach {
            $0.font.withSize(16)
            $0.textColor = .sand40
        }
        heights?.forEach({ $0.constant = 35 })
    }
}
