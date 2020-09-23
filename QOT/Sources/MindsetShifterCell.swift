//
//  MindsetShifterCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MindsetShifterCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var ctaButton: AnimatedButton!
    var negativeToPositiveView: NegativeToPositiveView?
    private var mindsetShifter: QDMMindsetShifter?
    @IBOutlet weak var sliderViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        negativeToPositiveView = R.nib.negativeToPositiveView.firstView(owner: self)
        negativeToPositiveView?.addTo(superview: sliderView, showSkeleton: true, darkMode: true)
        ThemeBorder.accent40.apply(ctaButton)
        skeletonManager.addOtherView(ctaButton)
        ctaButton.setButtonContentInset(padding: 16)
    }

    func configure(with viewModel: MindsetShifterViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: viewModel.title?.uppercased(), subtitle: viewModel.subtitle)
        negativeToPositiveView?.configure(title: "",
                                          lowTitle: AppTextService.get(.coach_tools_interactive_tool_minsdset_shifter_result_section_your_answers_title_neg_to_pos_low),
                                          lowItems: viewModel.mindsetShifter?.lowPerformanceAnswers?.compactMap { $0.subtitle ?? "" } ?? [],
                                          highTitle: AppTextService.get(.coach_tools_interactive_tool_minsdset_shifter_result_section_your_answers_title_neg_to_pos_high),
                                          highItems: viewModel.mindsetShifter?.highPerformanceContentItems.compactMap { $0.valueText } ?? [])
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply(viewModel.subtitle, to: baseHeaderView?.subtitleTextView)
        self.mindsetShifter = viewModel.mindsetShifter
        ctaButton.setTitle(AppTextService.get(.daily_brief_section_mindset_shifter_cta), for: .normal)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }

    @IBAction func mindsetButtonTapped(_ sender: Any) {
        delegate?.presentMindsetResults(for: mindsetShifter)
    }

    override func updateConstraints() {
        super.updateConstraints()
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        sliderViewHeightConstraint.constant = negativeToPositiveView?.calculateHeight(for: self.frame.size.width) ?? 0
    }
}
