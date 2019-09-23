//
//  DailyCheckinInsightsTBVCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsTBVCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var tbvText: UILabel!
    @IBOutlet private weak var button: AnimatedButton!
    var interactor: DailyBriefInteractorInterface?
    @IBOutlet private weak var introText: UILabel!
    @IBOutlet private weak var tbvSentence: UILabel!
    @IBOutlet private weak var adviceText: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with: DailyCheckIn2TBVModel?) {
        tbvText.text = with?.introText
        tbvSentence.text = with?.tbvSentence
        self.adviceText.text = with?.adviceText
        ThemeText.dailyBriefTitle.apply(with?.title, to: bucketTitle)
    }
}

private extension DailyCheckinInsightsTBVCell {
    @IBAction func toBeVisionButton(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
}
