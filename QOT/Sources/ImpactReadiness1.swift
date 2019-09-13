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
    @IBOutlet weak var bucketTitle: UILabel!
    @IBOutlet weak var impactReadinessScore: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var impactReadinessButton: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0
    @IBOutlet weak var impactReadinessView: UIImageView!
    var trackState: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        toBeVisionImage.gradientBackground(top: true)
        toBeVisionImage.gradientBackground(top: false)
    }

    @IBAction func impactReadinessButton(_ sender: Any) {
        // tell someone it's selected. -1 indicates the default condition.
        if score != -1 {
            trackState = !trackState
            impactReadinessButton.flipImage(trackState)
            NotificationCenter.default.post(name: .dispayDailyCheckInScore, object: nil)
        } else {
            delegate?.showDailyCheckIn()
        }
    }

    func configure(viewModel: ImpactReadinessCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: bucketTitle)
        ThemeText.sprintText.apply(viewModel?.readinessIntro, to: content)
        let score: Int = viewModel?.readinessScore ?? 0
        if score == -1 {
            ThemeText.readinessScore.apply(" - ", to: impactReadinessScore)
        } else {
            ThemeText.readinessScore.apply(String(score), to: impactReadinessScore)
        }
        toBeVisionImage.setImage(url: viewModel?.dailyCheckImageURL, placeholder: R.image.tbvPlaceholder())
        self.score = viewModel?.readinessScore ?? 0
        ThemeView.level1.apply(self)
    }
}
