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
    @IBOutlet weak var seeMyPlanButton: UIButton!

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


        ThemeText.tbvQuestionLight.apply(lowTitle, to: lowTitleLabel)
        ThemeText.tbvQuestionLight.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowFirstStatement)
        ThemeText.tbvQuestionLight.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowSecondStatement)
        ThemeText.tbvQuestionLight.apply(lowItems[0, default: "lowItem_\(0) not set"], to: lowThirdStatement)

        ThemeText.resultTitleTheme(.dark).apply(highTitle, to: highTitleLabel)
        ThemeText.resultHeaderTheme2(.dark).apply(highItems[0, default: "highItem_\(0) not set"], to: highFirstStatement)
        ThemeText.resultHeaderTheme2(.dark).apply(highItems[1, default: "highItem_\(1) not set"], to: highSecondStatement)
        ThemeText.resultHeaderTheme2(.dark).apply(highItems[2, default: "highItem_\(2) not set"], to: highThirdStatement)
        self.mindsetShifter = viewModel.mindsetShifter
    }

    func setupGradients() {
        let highGradientLayer = CAGradientLayer()
        let lowGradientLayer = CAGradientLayer()
        let highGradientColor1 = UIColor(red: 0.604, green: 0.851, blue: 0.514, alpha: 0.1).cgColor
        let highGradientColor2 = UIColor(red: 0.604, green: 0.847, blue: 0.514, alpha: 0).cgColor

        let lowGradientColor1 = UIColor(red: 0.816, green: 0.408, blue: 0.306, alpha: 0.1).cgColor
        let lowGradientColor2 = UIColor(red: 0.816, green: 0.408, blue: 0.306, alpha: 0).cgColor

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
