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
        toBeVisionImage.kf.setImage(with: viewModel?.dailyCheckImageView, placeholder: R.image.tbvPlaceholder())
        impactReadinessScore.text = String((viewModel?.readinessScore ?? 0))
        self.score = viewModel?.readinessScore ?? 0
        content.text = viewModel?.readinessIntro
    }
}
