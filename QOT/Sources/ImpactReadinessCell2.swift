//
//  ImpactReadinessCell2.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ImpactReadinessCell2: UITableViewCell, Dequeueable {

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
        self.howYouFeelToday.text = viewModel?.howYouFeelToday
        self.asterickText.text = viewModel?.asteriskText
        self.sleepQuantityTitle.text = viewModel?.impactDataModels?.at(index: 0)?.title
        self.sleepQuantitySubtitle.text = viewModel?.impactDataModels?.at(index: 0)?.subTitle
        self.sleepQuantity.text = String(viewModel?.sleepQuantityValue ?? 0)
        self.sleepQuantityTarget.text = String((viewModel?.targetSleepQuality ?? 0) * 5)

        self.sleepQualityTitle.text = viewModel?.impactDataModels?.at(index: 1)?.title
        self.sleepQualitySubtitle.text = viewModel?.impactDataModels?.at(index: 1)?.subTitle
        self.sleepQuality.text = String(viewModel?.sleepQualityValue ?? 0)
        self.sleepQualityRefrence.text = String(viewModel?.sleepQualityReference ?? 0)

        self.loadTitle.text = viewModel?.impactDataModels?.at(index: 2)?.title
        self.loadSubtitle.text = viewModel?.impactDataModels?.at(index: 2)?.subTitle
        self.load.text = String(viewModel?.loadValue ?? 0)
        self.loadRefrence.text = String(viewModel?.loadReference ?? 0)

        self.futureLoadTitle.text = viewModel?.impactDataModels?.at(index: 3)?.title
        self.futureLoadSubtitle.text = viewModel?.impactDataModels?.at(index: 3)?.subTitle
        self.futureLoad.text = String(viewModel?.futureLoadValue ?? 0)
        self.futureLoadRefrence.text = String(viewModel?.futureLoadReference ?? 0)

    }

    @IBAction func targetReference(_ sender: Any) {
        delegate?.showCustomizeTarget()

    }
}
