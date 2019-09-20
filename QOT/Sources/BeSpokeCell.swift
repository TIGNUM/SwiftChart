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
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var labelToTop: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(titleLabel)
        skeletonManager.addSubtitle(descriptionLabel)
        skeletonManager.addOtherView(firstImageView)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(titleLabel)
        skeletonManager.addSubtitle(descriptionLabel)
        skeletonManager.addOtherView(firstImageView)
    }

    @IBAction func copyrightPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: copyrightURL)
    }

    func configure(with viewModel: BeSpokeCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.bucketTitle ?? "").uppercased(), to: headingLabel)
        ThemeText.bespokeTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
        ThemeText.dailyBriefSubtitle.apply(model.description, to: descriptionLabel)
        skeletonManager.addOtherView(firstImageView)
        firstImageView.kf.setImage(with: URL(string: model.image ?? ""), placeholder: R.image.preloading(), options: nil, progressBlock: nil) { [weak self] (_) in
            self?.skeletonManager.hide()
        }
        copyrightURL = model.copyright
    }
}
