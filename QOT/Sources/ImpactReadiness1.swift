//
//  ImpactReadiness1.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ImpactReadiness1: UITableViewCell, Dequeueable {

    @IBOutlet weak var toBeVisionImage: UIImageView!
    @IBOutlet weak var bucketTitle: UILabel!
    @IBOutlet weak var impactReadinessScore: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var impactReadinessButton: UIButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0
    @IBOutlet weak var impactReadinessView: UIImageView!

    override func awakeFromNib() {
        impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        impactReadinessView.addFadeView(at: .bottom,
                         height: 120,
                         primaryColor: colorMode.background,
                         fadeColor: colorMode.fade)
    }

    @IBAction func impactReadinessButton(_ sender: Any) {
        // tell someone it's selected.
        if score != 0 {
             NotificationCenter.default.post(name: .dispayDailyCheckInScore, object: nil)
        } else {
            delegate?.showDailyCheckIn()
        }
    }

    func configure(viewModel: ImpactReadinessCellViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: bucketTitle)
        ThemeText.sprintText.apply(viewModel?.readinessIntro, to: content)
        ThemeText.readinessScore.apply(String(viewModel?.readinessScore ?? 0), to: impactReadinessScore)
        toBeVisionImage.kf.setImage(with: viewModel?.dailyCheckImageView, placeholder: R.image.tbvPlaceholder())
        self.score = viewModel?.readinessScore ?? 0
    }
}
