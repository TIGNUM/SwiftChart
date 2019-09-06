//
//  ImpactReadiness1.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ImpactReadiness1: BaseDailyBriefCell {

    @IBOutlet weak var toBeVisionImage: UIImageView!
    @IBOutlet weak var gradientTop: UIView!
    @IBOutlet weak var gradientBottom: UIView!
    @IBOutlet weak var bucketTitle: UILabel!
    @IBOutlet weak var impactReadinessScore: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var impactReadinessButton: UIButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0
    @IBOutlet weak var impactReadinessView: UIImageView!

    override func awakeFromNib() {
        impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        gradientTop.gradientBackground(top: true)
        gradientBottom.gradientBackground(top: false)
    }

    @IBAction func impactReadinessButton(_ sender: Any) {
        // tell someone it's selected. -1 indicates the default condition.
        if score != -1 {
             NotificationCenter.default.post(name: .dispayDailyCheckInScore, object: nil)
        } else {
            delegate?.showDailyCheckIn()
        }
    }

    func configure(viewModel: ImpactReadinessCellViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: bucketTitle)
        ThemeText.sprintText.apply(viewModel?.readinessIntro, to: content)
        let score: Int = viewModel?.readinessScore ?? 0
        if score == -1 {
            ThemeText.readinessScore.apply(" - ", to: impactReadinessScore)
        }
        else {
            ThemeText.readinessScore.apply(String(score), to: impactReadinessScore)
        }
        toBeVisionImage.setImage(url: viewModel?.dailyCheckImageURL, placeholder: R.image.tbvPlaceholder())
        self.score = viewModel?.readinessScore ?? 0
    }
}
