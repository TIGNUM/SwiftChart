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
        self.mindsetShifter = viewModel.mindsetShifter
        skeletonManager.hide()
        let lowTitle = AppTextService.get(.coach_tools_interactive_tool_minsdset_shifter_result_section_your_answers_title_neg_to_pos_low).lowercased().capitalizingFirstLetter()
        let lowItems = viewModel.mindsetShifter?.lowPerformanceAnswers?.compactMap { $0.subtitle ?? "" } ?? []
        let highTitle = AppTextService.get(.coach_tools_interactive_tool_minsdset_shifter_result_section_your_answers_title_neg_to_pos_high).lowercased().capitalizingFirstLetter()
        let highItems = viewModel.mindsetShifter?.highPerformanceContentItems.compactMap { $0.valueText } ?? []
        seeMyPlanButton.setTitle(AppTextService.get(AppTextKey.daily_brief_section_my_peak_performances_button_title), for: .normal)
        ThemeButton.whiteRounded.apply(seeMyPlanButton)

        ThemeText.tbvQuestionLow.apply(lowTitle, to: lowTitleLabel)
        ThemeText.tbvQuestionHigh.apply(highTitle, to: highTitleLabel)

        if lowItems.count > 0 {
            ThemeText.tbvQuestionLow.apply(lowItems[0], to: lowFirstStatement)
        }
        if lowItems.count > 1 {
            ThemeText.tbvQuestionLow.apply(lowItems.at(index: 1), to: lowSecondStatement)
        }
        if lowItems.count > 2 {
            ThemeText.tbvQuestionLow.apply(lowItems[2], to: lowThirdStatement)
        }

        if highItems.count > 0 {
            ThemeText.tbvQuestionHigh.apply(highItems[0], to: highFirstStatement)
        }
        if highItems.count > 1 {
            ThemeText.tbvQuestionHigh.apply(highItems[1], to: highSecondStatement)
        }
        if highItems.count > 2 {
            ThemeText.tbvQuestionHigh.apply(highItems[2], to: highThirdStatement)
        }

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
