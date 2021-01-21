//
//  ImpactReadiness5DaysRollingTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 15.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ImpactReadiness5DaysRollingTableViewCell: BaseDailyBriefCell {

    @IBOutlet weak var asterixText: UILabel!
    //// sleepQuantity
    @IBOutlet weak var sleepQuantityButton: UIButton!
    @IBOutlet weak var sleepQuantityTarget: UIButton!
    @IBOutlet weak var sleepQuantityScoreButton: UIButton!
    @IBOutlet weak var targetLabel: UILabel!
    ////  sleepquality

    @IBOutlet weak var sleepQualityButton: UIButton!
    @IBOutlet weak var sleepQualityScoreButton: UIButton!
    ////  load
    @IBOutlet weak var loadScoreButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    ////  futureload
    @IBOutlet weak var futureLoadButton: UIButton!
    @IBOutlet weak var futureLoadScoreButton: UIButton!
    ////  delagate
    @IBOutlet weak var mainStackView: UIStackView!
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?
    @IBOutlet weak var moreData: AnimatedButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dividerView1: UIView!
    @IBOutlet weak var dividerView2: UIView!
    @IBOutlet weak var dividerView3: UIView!
    @IBOutlet weak var trackedDaysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        moreData.corner(radius: Layout.cornerRadius20, borderColor: .white)
        skeletonManager.addSubtitle(asterixText)
        for view in mainStackView.arrangedSubviews {
            skeletonManager.addOtherView(view)
        }
        skeletonManager.addOtherView(moreData)
        ThemeView.level2.apply(contentView)
    }

    func hide(_ hidden: Bool) {
        asterixText.isHidden = hidden
        sleepQuantityButton.isHidden = hidden
        sleepQuantityScoreButton.isHidden = hidden
        sleepQuantityTarget.isHidden = hidden
        sleepQualityButton.isHidden = hidden
        sleepQualityScoreButton.isHidden = hidden
        loadButton.isHidden = hidden
        loadScoreButton.isHidden = hidden
        futureLoadButton.isHidden = hidden
        futureLoadScoreButton.isHidden = hidden
        moreData.isHidden = hidden
        dividerView.isHidden = hidden
        dividerView1.isHidden = hidden
        dividerView2.isHidden = hidden
        dividerView3.isHidden = hidden
    }

    func configure(viewModel: ImpactReadinessScoreViewModel?) {
        if viewModel?.domainModel?.dailyCheckInResult != nil {
            hide(false)
            skeletonManager.hide()
        }
        var asterixCharacter = "*"

        if viewModel?.hasFiveDayLoadValue != true,
            viewModel?.hasFiveDaySleepQualityValue != true,
            viewModel?.hasFiveDaySleepQuantityValues != true {
            asterixText.attributedText = buildString(asterixCharacter,
                                                     ThemeText.dailyBriefSubtitle,
                                                     (viewModel?.asteriskText ?? "").replacingOccurrences(of: asterixCharacter, with: ""),
                                                     ThemeText.asterixText,
                                                     textAlignment: .left)
        } else {
            asterixText.attributedText = nil
        }

        asterixCharacter = viewModel?.hasFiveDaySleepQuantityValues == true ? "" : "*"
        let asteriskQuality = viewModel?.hasFiveDaySleepQualityValue == true ? "" : "*"
        let asteriskLoad = viewModel?.hasFiveDayLoadValue == true ? "" : "*"

        // Sleep Quantity
        let quantityTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quantity_new_title).uppercased()
        sleepQuantityButton.setTitle(quantityTitle, for: .normal)
        let hour = " " + AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quantity_label_h)
        let targetSleepQuantityInFiveDays = (viewModel?.targetSleepQuantity ?? 8) * 5
        let textColor: UIColor = viewModel?.hasFiveDaySleepQuantityValues == true &&
                                        viewModel?.sleepQuantityValue?.isLess(than: targetSleepQuantityInFiveDays) == true ?
                                            .redOrange : .white
        sleepQuantityScoreButton.setTitleColor(textColor, for: .normal)
        sleepQuantityScoreButton.setTitle(String(viewModel?.sleepQuantityValue ?? 0) + hour, for: .normal)
        sleepQuantityTarget.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_customize_button), for: .normal)
        let target =  "/ " + String(targetSleepQuantityInFiveDays) + hour

        ThemeText.reference.apply(target, to: targetLabel)

        // Sleep Quality
        let qualityReference = Double(AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quality_number_ref))
        let qualityTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quality_new_title)
        sleepQualityButton.setTitle(qualityTitle, for: .normal)
        let qualityTextColor: UIColor = qualityReference?.isLess(than: viewModel?.sleepQualityValue ?? 0) == true ? .white : .redOrange
        sleepQualityScoreButton.setTitleColor(qualityTextColor, for: .normal)
        sleepQualityScoreButton.setTitle(String(viewModel?.sleepQualityValue ?? 0) + asteriskQuality, for: .normal)

        // Load
        let loadReference = Double(AppTextService.get(.daily_brief_section_impact_readiness_section_load_number_ref))
        let loadTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_load_new_title)
        loadButton.setTitle(loadTitle, for: .normal)

        let loadTextColor: UIColor = viewModel?.loadValue?.isLess(than: loadReference ?? 0) == true ? .white : .redOrange
        loadScoreButton.setTitleColor(loadTextColor, for: .normal)
        loadScoreButton.setTitle(String(viewModel?.loadValue ?? 0) + asteriskLoad, for: .normal)

        // Future Load
        let futureLoadReference = Double(AppTextService.get(.daily_brief_section_impact_readiness_section_future_load_number_ref))
        let futureLoadTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_future_load_new_title)
        futureLoadButton.setTitle(futureLoadTitle, for: .normal)

        let futureLoadTextColor: UIColor = viewModel?.futureLoadValue?.isLess(than: futureLoadReference ?? 0) == true ? .white : .redOrange
        futureLoadScoreButton.setTitleColor(futureLoadTextColor, for: .normal)
        futureLoadScoreButton.setTitle(String(viewModel?.futureLoadValue ?? 0) + asteriskLoad, for: .normal)
        // Tracked days
        if let  numberOfDays = viewModel?.maxTrackingDays {
        let trackedDays = AppTextService.get(.daily_brief_section_impact_readiness_body_tracking_days).replacingOccurrences(of: "max_tracking_days",
                                                                                                                            with: String(numberOfDays))
        ThemeText.trackedDays.apply(trackedDays, to: trackedDaysLabel)
        }

        // Button
        moreData.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_button_my_data).uppercased(), for: .normal)
    }

    @IBAction func sleepQuantityTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_sleep_quantity_description))
    }

    @IBAction func sleepQuantityScoreTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_sleep_quantity_description))
    }

    @IBAction func sleepQualityTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_sleep_quality_description))
    }

    @IBAction func sleepQualityScoreTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_sleep_quality_description))
    }

    @IBAction func loadButtonTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_load_description))
    }

    @IBAction func loadScoreTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_load_description))
    }

    @IBAction func futureLoadTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_future_load_description))
    }

    @IBAction func futureLoadScoreTapped(_ sender: Any) {
        delegate?.showAlert(message: AppTextService.get(.daily_brief_section_impact_readiness_future_load_description))
    }

    @IBAction func targetReference(_ sender: Any) {
        delegate?.showCustomizeTarget()
    }

    @IBAction func presentMyData(_ sender: Any) {
        delegate?.presentMyDataScreen()
    }

    private func buildString(_ text1: String, _ theme1: ThemeText,
                             _ text2: String, _ theme2: ThemeText,
                             _ text3: String? = nil, _ theme3: ThemeText? = nil,
                             _ text4: String? = nil, _ theme4: ThemeText? = nil,
                             textAlignment: NSTextAlignment = .right) -> NSAttributedString {

        let combine = NSMutableAttributedString()
        combine.append(theme1.attributedString(text1))
        combine.append(theme2.attributedString(text2))
        if let text3 = text3,
           let theme3 = theme3 {
            combine.append(theme3.attributedString(text3))
        }
        if let text4 = text4,
            let theme4 = theme4 {
            combine.append(theme4.attributedString(text4))
        }
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        combine.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: combine.length))
        return combine
    }
}
