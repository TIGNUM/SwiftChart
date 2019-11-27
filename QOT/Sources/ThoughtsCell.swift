//
//  ThoughtsCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ThoughtsCell: BaseDailyBriefCell {
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(authorLabel)
    }

    func configure(with viewModel: ThoughtsCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.thought)
        ThemeText.quotation.apply(model.thought, to: baseHeaderView?.subtitleTextView)
        ThemeText.quoteAuthor.apply(model.author, to: authorLabel)
    }
}
