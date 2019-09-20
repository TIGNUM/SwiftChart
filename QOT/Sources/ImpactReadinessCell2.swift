//
//  ImpactReadinessCell2.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ImpactReadinessCell2: BaseDailyBriefCell {

    @IBOutlet weak var howYouFeelToday: UILabel!
    @IBOutlet weak var asterickText: UILabel!
//// sleepQuantity
    @IBOutlet weak var sleepQuantityTitle: UILabel!
    @IBOutlet weak var sleepQuantitySubtitle: UILabel!
    @IBOutlet weak var sleepQuantity: UILabel!
    @IBOutlet weak var sleepQuantityTarget: UIButton!
    ////  sleepquality
    @IBOutlet weak var sleepQualityTitle: UILabel!
    @IBOutlet weak var sleepQualitySubtitle: UILabel!
    @IBOutlet weak var sleepQuality: UILabel!
    @IBOutlet weak var sleepQualityRefrence: UILabel!
////  load
    @IBOutlet weak var loadTitle: UILabel!
    @IBOutlet weak var loadSubtitle: UILabel!
    @IBOutlet weak var load: UILabel!
    @IBOutlet weak var loadRefrence: UILabel!
////  futureload
    @IBOutlet weak var futureLoadTitle: UILabel!
    @IBOutlet weak var futureLoadSubtitle: UILabel!
    @IBOutlet weak var futureLoad: UILabel!
    @IBOutlet weak var futureLoadRefrence: UILabel!
////  delagate
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

    override func awakeFromNib() {
        super.awakeFromNib()
        moreData.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        ThemeView.level2.apply(self)
    }

    func hide(_ hidden: Bool) {
        rollingDataLabel.isHidden = hidden
        howYouFeelToday.isHidden = hidden
        asterickText.isHidden = hidden
        sleepQuantityTitle.isHidden = hidden
        sleepQuantitySubtitle.isHidden = hidden
        sleepQuantity.isHidden = hidden
        sleepQuantityTarget.isHidden = hidden
        sleepQualityTitle.isHidden = hidden
        sleepQualitySubtitle.isHidden = hidden
        sleepQuality.isHidden = hidden
        sleepQualityRefrence.isHidden = hidden
        loadTitle.isHidden = hidden
        loadSubtitle.isHidden = hidden
        load.isHidden = hidden
        loadRefrence.isHidden = hidden
        futureLoadTitle.isHidden = hidden
        futureLoadSubtitle.isHidden = hidden
        futureLoad.isHidden = hidden
        futureLoadRefrence.isHidden = hidden
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
            self.removeLoadingSkeleton()
        } else {
            hide(true)
            self.showLoadingSkeleton(with: [.dailyCheckInHeader,
                                            .dailyCheckInRow,
                                            .dailyCheckInRow,
                                            .dailyCheckInFooter])
        }

        ThemeText.dailyBriefImpactReadinessRolling.apply(R.string.localized.dailyBriefImpactReadinessRollingData().uppercased(), to: rollingDataLabel)
        ThemeText.dailyBriefSubtitle.apply(viewModel?.howYouFeelToday, to: howYouFeelToday)
        ThemeText.dailyBriefSubtitle.apply(viewModel?.asteriskText, to: asterickText)
        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 0)?.title ?? "").uppercased(), to: sleepQuantityTitle)

        sleepQuantity.attributedText = buildString(String(format: "%.1f", viewModel?.sleepQuantityValue ?? 0),
                                                   ThemeText.quotation,
                                                   "h",
                                                   ThemeText.quotationSmall)

        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 0)?.subTitle, to: sleepQuantitySubtitle)
        let targetSleepQuantityInFiveDays = (viewModel?.targetSleepQuality ?? viewModel?.sleepQualityReference ?? 0) * 5
        sleepQuantityTarget.setTitle(String(targetSleepQuantityInFiveDays), for: .normal)

        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 1)?.title ?? "").uppercased(), to: sleepQualityTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 1)?.subTitle, to: sleepQualitySubtitle)
        sleepQuality.attributedText = buildString(String(format: "%.1f", viewModel?.sleepQualityValue ?? 0),
                                                  ThemeText.quotation,
                                                  "/",
                                                  ThemeText.quotationSlash,
                                                  "10",
                                                  ThemeText.quotationLight)
        ThemeText.reference.apply(String(viewModel?.sleepQualityReference ?? 0), to: sleepQualityRefrence)

        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 2)?.title ?? "").uppercased(), to: loadTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 2)?.subTitle, to: loadSubtitle)
        load.attributedText = buildString(String(format: "%.1f", viewModel?.loadValue ?? 0),
                                          ThemeText.quotation,
                                          "/",
                                          ThemeText.quotationSlash,
                                          "10",
                                          ThemeText.quotationLight)
        ThemeText.reference.apply(String(viewModel?.loadReference ?? 0), to: loadRefrence)

        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 3)?.title ?? "").uppercased(), to: futureLoadTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 3)?.subTitle, to: futureLoadSubtitle)
        futureLoad.attributedText = buildString(String(format: "%.1f", viewModel?.futureLoadValue ?? 0),
                                                ThemeText.quotation,
                                                "/",
                                                ThemeText.quotationSlash,
                                                "10",
                                                ThemeText.quotationLight)
        ThemeText.reference.apply(String(viewModel?.futureLoadReference ?? 0), to: futureLoadRefrence)
    }

    @IBAction func targetReference(_ sender: Any) {
            delegate?.showCustomizeTarget()
    }
    @IBAction func presentMyData(_ sender: Any) {
            delegate?.presentMyDataScreen()
    }

    private func buildString(_ text1: String, _ theme1: ThemeText,
                             _ text2: String, _ theme2: ThemeText,
                             _ text3: String? = nil, _ theme3: ThemeText? = nil) -> NSAttributedString {

        let combine = NSMutableAttributedString()
        combine.append(theme1.attributedString(text1))
        combine.append(theme2.attributedString(text2))
        if let text3 = text3,
           let theme3 = theme3 {
            combine.append(theme3.attributedString(text3))
        }
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        combine.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: combine.length))
        return combine
    }
}
