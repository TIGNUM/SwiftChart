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
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var goodToKnowModel: GoodToKnowCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(goodToKnowFact)
        skeletonManager.addOtherView(goodToKnowImage)
    }

    func configure(with viewModel: GoodToKnowCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        skeletonManager.addOtherView(goodToKnowImage)
        goodToKnowImage.setImage(url: model.image,
                                 skeletonManager: self.skeletonManager)
        baseHeaderview?.configure(title: (model.title ?? "").uppercased(), subtitle: nil)
        ThemeText.dailyBriefSubtitle.apply(model.fact, to: goodToKnowFact)
        self.goodToKnowModel = model
    }
}
