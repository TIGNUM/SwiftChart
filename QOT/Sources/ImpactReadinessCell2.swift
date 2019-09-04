//
//  ImpactReadinessCell2.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ImpactReadinessCell2: BaseDailyBriefCell {

    @IBOutlet weak var rollingDataLabel: UILabel!
    @IBOutlet weak var howYouFeelToday: UILabel!
    @IBOutlet weak var asterickText: UILabel!
// sleepQuantity
    @IBOutlet weak var sleepQuantityTitle: UILabel!
    @IBOutlet weak var sleepQuantitySubtitle: UILabel!
    @IBOutlet weak var sleepQuantity: UILabel!
    @IBOutlet weak var sleepQuantityTarget: UILabel!
//  sleepquality
    @IBOutlet weak var sleepQualityTitle: UILabel!
    @IBOutlet weak var sleepQualitySubtitle: UILabel!
    @IBOutlet weak var sleepQuality: UILabel!
    @IBOutlet weak var sleepQualityRefrence: UILabel!
//  load
    @IBOutlet weak var loadTitle: UILabel!
    @IBOutlet weak var loadSubtitle: UILabel!
    @IBOutlet weak var load: UILabel!
    @IBOutlet weak var loadRefrence: UILabel!
//  futureload
    @IBOutlet weak var futureLoadTitle: UILabel!
    @IBOutlet weak var futureLoadSubtitle: UILabel!
    @IBOutlet weak var futureLoad: UILabel!
    @IBOutlet weak var futureLoadRefrence: UILabel!
//  delagate
    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet weak var moreData: UIButton!

    override func awakeFromNib() {
        moreData.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(viewModel: ImpactReadinessScoreViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.sprintText.apply(viewModel?.howYouFeelToday, to: howYouFeelToday)
        ThemeText.asterix.apply(viewModel?.asteriskText, to: asterickText)
        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 0)?.title ?? "").uppercased(), to: sleepQuantityTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 0)?.subTitle, to: sleepQuantitySubtitle)
        ThemeText.quotation.apply(String(format: "%.2f", viewModel?.sleepQuantityValue ?? 0), to: sleepQuantity)
        let targetSleepQuantityInFiveDays = (viewModel?.targetSleepQuality ?? viewModel?.sleepQualityReference ?? 0) * 5
        ThemeText.sleepReference.apply(String(targetSleepQuantityInFiveDays), to: sleepQuantityTarget)

        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 1)?.title ?? "").uppercased(), to: sleepQualityTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 1)?.subTitle, to: sleepQualitySubtitle)
        ThemeText.quotation.apply(String(viewModel?.sleepQualityValue ?? 0), to: sleepQuality)
        ThemeText.reference.apply(String(viewModel?.sleepQualityReference ?? 0), to: sleepQualityRefrence)

        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 2)?.title ?? "").uppercased(), to: loadTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 2)?.subTitle, to: loadSubtitle)
        ThemeText.quotation.apply(String(viewModel?.loadValue ?? 0), to: load)
        ThemeText.reference.apply(String(viewModel?.loadReference ?? 0), to: loadRefrence)

        ThemeText.sprintTitle.apply((viewModel?.impactDataModels?.at(index: 3)?.title ?? "").uppercased(), to: futureLoadTitle)
        ThemeText.durationString.apply(viewModel?.impactDataModels?.at(index: 3)?.subTitle, to: futureLoadSubtitle)
        ThemeText.quotation.apply(String(viewModel?.futureLoadValue ?? 0), to: futureLoad)
        ThemeText.reference.apply(String(viewModel?.futureLoadReference ?? 0), to: futureLoadRefrence)
    }

    @IBAction func targetReference(_ sender: Any) {
        delegate?.showCustomizeTarget()
    }
    @IBAction func presentMyData(_ sender: Any) {
        delegate?.presentMyDataScreen()
    }
}
