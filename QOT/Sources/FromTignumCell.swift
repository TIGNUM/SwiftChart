//
//  FromTignumCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class FromTignumCell: BaseDailyBriefCell {

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var fromTignumText: UILabel!
    private var detailsExpanded = false
    private var link: QDMAppLink?
    @IBOutlet private weak var ctaButton: AnimatedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(fromTignumText)
    }

    @IBAction func discoverButton(_ sender: Any) {
        detailsExpanded.toggle()
    }

    func configure(with viewModel: FromTignumCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.subtitle)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefFromTignumTitle.apply((model.subtitle ?? ""), to: baseHeaderView?.subtitleTextView)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.bespokeText.apply(model.text, to: fromTignumText)
        if let ctaText = model.cta {
            ctaButton.setTitle(ctaText, for: .normal)
            ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
            ctaButton.setButtonContentInset(padding: 16)
        } else {
            ctaButton.isHidden = true
        }
        self.link = model.link
    }

    @IBAction func ctaButtonTapped(_ sender: Any) {
         link?.launch()
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }
}
