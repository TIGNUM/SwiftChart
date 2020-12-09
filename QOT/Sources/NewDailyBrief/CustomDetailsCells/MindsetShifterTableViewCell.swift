//
//  MindsetShifterTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class MindsetShifterTableViewCell: BaseDailyBriefCell {
    @IBOutlet weak var highView: UIView!
    @IBOutlet weak var highTitleLabel: UILabel!
    @IBOutlet weak var highFirstStatement: UILabel!
    @IBOutlet weak var highSecondStatement: UILabel!
    @IBOutlet weak var highThirdStatement: UILabel!

    @IBOutlet weak var lowView: UIView!
    @IBOutlet weak var lowTitleLabel: UILabel!
    @IBOutlet weak var lowFirstStatement: UILabel!
    @IBOutlet weak var lowSecondStatement: UILabel!
    @IBOutlet weak var lowThirdStatement: UILabel!
    @IBOutlet weak var seeMyPlanButton: RoundedButton!

    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?
    private var mindsetShifter: QDMMindsetShifter?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupGradients()
    }

    func configure(with viewModel: MindsetShifterViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        let lowTitle = AppTextService.get(.coach_tools_interactive_tool_minsdset_shifter_result_section_your_answers_title_neg_to_pos_low).lowercased().capitalizingFirstLetter()
        let lowItems = viewModel.mindsetShifter?.lowPerformanceAnswers?.compactMap { $0.subtitle ?? "" } ?? []
        let highTitle = AppTextService.get(.coach_tools_interactive_tool_minsdset_shifter_result_section_your_answers_title_neg_to_pos_high).lowercased().capitalizingFirstLetter()
        let highItems = viewModel.mindsetShifter?.highPerformanceContentItems.compactMap { $0.valueText } ?? []
        seeMyPlanButton.setTitle(AppTextService.get(AppTextKey.daily_brief_section_my_peak_performances_button_title), for: .normal)
        ThemeButton.whiteRounded.apply(seeMyPlanButton)

        ThemeText.tbvQuestionLow.apply(lowTitle, to: lowTitleLabel)
        ThemeText.tbvQuestionLow.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowFirstStatement)
        ThemeText.tbvQuestionLow.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowSecondStatement)
        ThemeText.tbvQuestionLow.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowThirdStatement)

        ThemeText.tbvQuestionLow.apply(highTitle, to: highTitleLabel)
        ThemeText.tbvQuestionHigh.apply(highItems[0, default: "highItem_\(0) not set"], to: highFirstStatement)
        ThemeText.tbvQuestionHigh.apply(highItems[1, default: "highItem_\(1) not set"], to: highSecondStatement)
        ThemeText.tbvQuestionHigh.apply(highItems[2, default: "highItem_\(2) not set"], to: highThirdStatement)
        self.mindsetShifter = viewModel.mindsetShifter
    }

    func setupGradients() {
        let highGradientLayer = CAGradientLayer()
        let lowGradientLayer = CAGradientLayer()
        let highGradientColor1 = UIColor.mindsetShifterGreen.withAlphaComponent(0.3).cgColor
        let highGradientColor2 = UIColor.mindsetShifterGreen.withAlphaComponent(0).cgColor

        let lowGradientColor1 = UIColor.mindsetShifterRed.withAlphaComponent(0.3).cgColor
        let lowGradientColor2 = UIColor.mindsetShifterRed.withAlphaComponent(0).cgColor

        highGradientLayer.colors = [highGradientColor1, highGradientColor2]
        highGradientLayer.locations = [0.0, 1.0]
        highGradientLayer.frame = highView.bounds

        lowGradientLayer.colors = [lowGradientColor1, lowGradientColor2]
        lowGradientLayer.locations = [0.0, 1.0]
        lowGradientLayer.frame = lowView.bounds

        highView.layer.insertSublayer(highGradientLayer, at: 0)
        highView.layer.masksToBounds = true

        lowView.layer.insertSublayer(lowGradientLayer, at: 0)
        lowView.layer.masksToBounds = true
    }

    @IBAction func mindsetButtonTapped(_ sender: Any) {
        delegate?.presentMindsetResults(for: mindsetShifter)
    }
}
