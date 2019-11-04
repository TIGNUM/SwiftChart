//
//  GoodToKnowCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class GoodToKnowCell: BaseDailyBriefCell {
    @IBOutlet private weak var goodToKnowImage: UIImageView!
    @IBOutlet private weak var goodToKnowFact: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var goodToKnowModel: GoodToKnowCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(goodToKnowFact)
        skeletonManager.addOtherView(goodToKnowImage)
    }

    func configure(with viewModel: GoodToKnowCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        skeletonManager.addOtherView(goodToKnowImage)
        goodToKnowImage.setImage(url: model.image,
                                 skeletonManager: self.skeletonManager) { (_) in /* */}
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
        ThemeText.dailyBriefSubtitle.apply(model.fact, to: goodToKnowFact)
        self.goodToKnowModel = model
    }
}
