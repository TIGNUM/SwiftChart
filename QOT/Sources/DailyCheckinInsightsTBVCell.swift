//
//  DailyCheckinInsightsTBVCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsTBVCell: BaseDailyBriefCell {

    @IBOutlet private weak var tbvText: UILabel!
    @IBOutlet private weak var button: AnimatedButton!
    var interactor: DailyBriefInteractorInterface?
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var tbvSentence: UILabel!
    @IBOutlet private weak var adviceText: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addTitle(tbvText)
        skeletonManager.addSubtitle(tbvSentence)
        skeletonManager.addSubtitle(adviceText)
        skeletonManager.addOtherView(button)
    }

    func configure(with: DailyCheckIn2TBVModel?) {
        guard let model = with else { return }
#warning("The title is hardcoded in the xib for this cell, need to change to localized string ASAP")
        skeletonManager.hide()
        tbvText.text = model.introText
        tbvSentence.text = model.tbvSentence
        self.adviceText.text = model.adviceText
    }
}

private extension DailyCheckinInsightsTBVCell {
    @IBAction func toBeVisionButton(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
}
