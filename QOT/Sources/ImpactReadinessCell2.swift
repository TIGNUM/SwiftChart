//
//  ImpactReadinessCell2.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ImpactReadinessCell2: BaseDailyBriefCell {

    @IBOutlet weak var howYouFeelToday: UILabel!
    @IBOutlet weak var asterixText: UILabel!
//// sleepQuantity
    @IBOutlet weak var sleepQuantityTitleLabel: UILabel!
    @IBOutlet weak var sleepQuantitySubtitleLabel: UILabel!
    @IBOutlet weak var sleepQuantityLabel: UILabel!
    @IBOutlet weak var sleepQuantityTarget: UIButton!
    ////  sleepquality
    @IBOutlet weak var sleepQualityTitle: UILabel!
    @IBOutlet weak var sleepQualitySubtitle: UILabel!
    @IBOutlet weak var sleepQualityLabel: UILabel!
    @IBOutlet weak var sleepQualityReferenceLabel: UILabel!
////  load
    @IBOutlet weak var loadTitleLabel: UILabel!
    @IBOutlet weak var loadSubtitleLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var loadReferenceLabel: UILabel!
////  futureload
    @IBOutlet weak var futureLoadTitleLabel: UILabel!
    @IBOutlet weak var futureLoadSubtitleLabel: UILabel!
    @IBOutlet weak var futureLoadLabel: UILabel!
    @IBOutlet weak var futureLoadReferenceLabel: UILabel!
////  delagate
    @IBOutlet weak var mainStackView: UIStackView!
    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet weak var moreData: AnimatedButton!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dividerView1: UIView!
    @IBOutlet weak var dividerView2: UIView!
    @IBOutlet weak var dividerView3: UIView!
    @IBOutlet weak var refLabel1: UILabel!
    @IBOutlet weak var refLabel2: UILabel!
    @IBOutlet weak var refLabel3: UILabel!
    @IBOutlet weak var rollingDataLabel: UILabel!
    @IBOutlet weak var trackedDaysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        moreData.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        skeletonManager.addSubtitle(rollingDataLabel)
        skeletonManager.addSubtitle(howYouFeelToday)
        skeletonManager.addSubtitle(asterixText)
        for view in mainStackView.arrangedSubviews {
            skeletonManager.addOtherView(view)
        }
        skeletonManager.addOtherView(moreData)
        ThemeView.level2.apply(contentView)
    }

    func hide(_ hidden: Bool) {
        rollingDataLabel.isHidden = hidden
        howYouFeelToday.isHidden = hidden
        asterixText.isHidden = hidden
        sleepQuantityTitleLabel.isHidden = hidden
        sleepQuantitySubtitleLabel.isHidden = hidden
        sleepQuantityLabel.isHidden = hidden
        sleepQuantityTarget.isHidden = hidden
        sleepQualityTitle.isHidden = hidden
        sleepQualitySubtitle.isHidden = hidden
        sleepQualityLabel.isHidden = hidden
        sleepQualityReferenceLabel.isHidden = hidden
        loadTitleLabel.isHidden = hidden
        loadSubtitleLabel.isHidden = hidden
        loadLabel.isHidden = hidden
        loadReferenceLabel.isHidden = hidden
        futureLoadTitleLabel.isHidden = hidden
        futureLoadSubtitleLabel.isHidden = hidden
        futureLoadLabel.isHidden = hidden
        futureLoadReferenceLabel.isHidden = hidden
        moreData.isHidden = hidden
        targetLabel.isHidden = hidden
        dividerView.isHidden = hidden
        dividerView1.isHidden = hidden
        dividerView2.isHidden = hidden
        dividerView3.isHidden = hidden
        refLabel1.isHidden = hidden
        refLabel2.isHidden = hidden
        refLabel3.isHidden = hidden
    }

    func configure(viewModel: ImpactReadinessScoreViewModel?) {

        if viewModel?.domainModel?.dailyCheckInResult != nil {
            hide(false)
            skeletonManager.hide()
        }
        var asterixCharacter = "*"
        ThemeText.dailyBriefImpactReadinessRolling.apply(AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_title).uppercased(), to: rollingDataLabel)
        ThemeText.dailyBriefSubtitle.apply(viewModel?.howYouFeelToday, to: howYouFeelToday)

        if viewModel?.hasFiveDayLoadValue != true,
            viewModel?.hasFiveDaySleepQualityValue != true,
            viewModel?.hasFiveDaySleepQuantityValues != true {
            asterixText.attributedText = buildString(asterixCharacter,
                                                     ThemeText.dailyBriefSubtitle,
                                                     (viewModel?.asteriskText ?? "").replacingOccurrences(of: asterixCharacter, with: ""),
                                                     ThemeText.dailyBriefSubtitle,
                                                     textAlignment: .left)
        } else {
            asterixText.attributedText = nil
        }

        asterixCharacter = viewModel?.hasFiveDaySleepQuantityValues == true ? "" : "*"
        let asteriskQuality = viewModel?.hasFiveDaySleepQualityValue == true ? "" : "*"
        let asteriskLoad = viewModel?.hasFiveDayLoadValue == true ? "" : "*"

        // Sleep Quantity
        let quantityTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quantity_title)
        let quantitySubtitle = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quantity_subtitle)
        ThemeText.bucketTitle.apply(quantityTitle, to: sleepQuantityTitleLabel)
        ThemeText.durationString.apply(quantitySubtitle, to: sleepQuantitySubtitleLabel)

        sleepQuantityLabel.attributedText = buildString(String(format: "%.1f", viewModel?.sleepQuantityValue ?? 0),
                                                        ThemeText.quotation,
                                                        AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quantity_label_h),
                                                        ThemeText.quotationSmall)
        let targetSleepQuantityInFiveDays = (viewModel?.targetSleepQuantity ?? 8) * 5
        targetLabel.text = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quantity_label_target)
        sleepQuantityTarget.setTitle(String(targetSleepQuantityInFiveDays), for: .normal)

        // Sleep Quality
        let qualityTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quality_title)
        let qualitySubtitle = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quality_subtitle)
        ThemeText.bucketTitle.apply(qualityTitle, to: sleepQualityTitle)
        ThemeText.durationString.apply(qualitySubtitle, to: sleepQualitySubtitle)

        sleepQualityLabel.attributedText = buildString(String(format: "%.1f", viewModel?.sleepQualityValue ?? 0),
                                                  ThemeText.quotation,
                                                  asteriskQuality,
                                                  ThemeText.quotation,
                                                  "/",
                                                  ThemeText.quotationSlash,
                                                  "10",
                                                  ThemeText.quotationLight)
        refLabel1.text = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quality_label_ref)
        ThemeText.reference.apply(String(viewModel?.sleepQualityReference ?? 0), to: sleepQualityReferenceLabel)

        // Load
        let loadTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_load_title)
        let loadSubtitle = AppTextService.get(.daily_brief_section_impact_readiness_section_load_subtitle)
        ThemeText.bucketTitle.apply(loadTitle, to: loadTitleLabel)
        ThemeText.durationString.apply(loadSubtitle, to: loadSubtitleLabel)

        loadLabel.attributedText = buildString(String(format: "%.1f", viewModel?.loadValue ?? 0),
                                          ThemeText.quotation,
                                          asteriskLoad,
                                          ThemeText.quotation,
                                          "/",
                                          ThemeText.quotationSlash,
                                          "10",
                                          ThemeText.quotationLight)
        refLabel2.text = AppTextService.get(.daily_brief_section_impact_readiness_section_load_label_ref)
        ThemeText.reference.apply(String(viewModel?.loadReference ?? 0), to: loadReferenceLabel)
        // Future Load
        let futureLoadTitle = AppTextService.get(.daily_brief_section_impact_readiness_section_future_load_title)
        let futureLoadSubtitle = AppTextService.get(.daily_brief_section_impact_readiness_section_future_load_subtitle)
        ThemeText.bucketTitle.apply(futureLoadTitle, to: futureLoadTitleLabel)
        ThemeText.durationString.apply(futureLoadSubtitle, to: futureLoadSubtitleLabel)

        futureLoadLabel.attributedText = buildString(String(format: "%.1f", viewModel?.futureLoadValue ?? 0),
                                                     ThemeText.quotation,
                                                     asteriskLoad,
                                                     ThemeText.quotation,
                                                     "/",
                                                     ThemeText.quotationSlash,
                                                     "10",
                                                     ThemeText.quotationLight)
        refLabel3.text = AppTextService.get(.daily_brief_section_impact_readiness_section_future_load_label_ref)
        ThemeText.reference.apply(String(viewModel?.futureLoadReference ?? 0), to: futureLoadReferenceLabel)
        // Tracked days
        if let  numberOfDays = viewModel?.maxTrackingDays {
            let trackedDays = AppTextService.get(.daily_brief_section_impact_readiness_body_tracking_days).replacingOccurrences(of: "max_tracking_days", with: String(numberOfDays))
            ThemeText.trackedDays.apply(trackedDays, to: trackedDaysLabel)
        }

        // Button
        moreData.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_button_my_data), for: .normal)
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
