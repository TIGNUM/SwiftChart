//
//  ThoughtsCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ThoughtsCell: BaseDailyBriefCell {
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(authorLabel)
    }

    func configure(with viewModel: ThoughtsCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderview?.configure(title: (model.title ?? "").uppercased(), subtitle: model.thought)
        ThemeText.quotation.apply(model.thought, to: baseHeaderview?.subtitleTextView)
        ThemeText.quoteAuthor.apply(model.author, to: authorLabel)
    }
}
