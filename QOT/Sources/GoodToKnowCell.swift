//
//  GoodToKnowCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class GoodToKnowCell: BaseDailyBriefCell {
    @IBOutlet private weak var goodToKnowFact: ClickableLabel!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var goodToKnowModel: GoodToKnowCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(goodToKnowFact)
    }

    func configure(with viewModel: GoodToKnowCellViewModel?) {
        guard let model = viewModel else { return }
        goodToKnowFact.delegate = clickableLinkDelegate
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: nil)
        ThemeText.dailyBriefSubtitle.apply(model.fact, to: goodToKnowFact)
        self.goodToKnowModel = model
    }
}
