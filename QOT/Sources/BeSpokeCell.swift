//
//  BeSpokeCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class BeSpokeCell: BaseDailyBriefCell {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var firstImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var tilteContainerView: UIView!
    @IBOutlet private weak var descriptionContainerView: UIView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var labelToTop: NSLayoutConstraint!

    @IBAction func copyrightPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: copyrightURL)
    }

    func configure(with viewModel: BeSpokeCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.bucketTitle ?? "").uppercased(), to: headingLabel)
        ThemeText.bespokeTitle.apply((viewModel?.title ?? "").uppercased(), to: titleLabel)
        ThemeText.dailyBriefSubtitle.apply(viewModel?.description, to: descriptionLabel)
        firstImageView.kf.setImage(with: URL(string: viewModel?.image ?? ""), placeholder: R.image.preloading())
        copyrightURL = viewModel?.copyright ?? ""
        if copyrightURL == "" {
            copyrightLabel.frame.size.height = 0
            labelToTop.constant = 22
            copyrightLabel.isHidden = true
        }
    }
}
