//
//  BeSpokeCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class BeSpokeCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!

    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet weak var labelToTop: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.subtitleTextView.text = ""
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(descriptionLabel)
        skeletonManager.addOtherView(firstImageView)
    }

    @IBAction func copyrightPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: copyrightURL)
    }

    func configure(with viewModel: BeSpokeCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderview?.configure(title: model.title,
                                  subtitle: nil)
        ThemeText.dailyBriefTitle.apply((model.bucketTitle ?? "").uppercased(), to: baseHeaderview?.titleLabel)
        ThemeText.bespokeTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
        ThemeText.dailyBriefSubtitle.apply(model.description, to: descriptionLabel)
        skeletonManager.addOtherView(firstImageView)
        firstImageView.setImage(url: URL(string: model.image ?? ""),
                                skeletonManager: self.skeletonManager)
        copyrightURL = model.copyright
        if copyrightURL?.isEmpty ?? true {
            copyrightButtonHeight.constant = 0
            labelToTop.constant = 22
            copyrightLabel.isHidden = true
        }
    }
}
