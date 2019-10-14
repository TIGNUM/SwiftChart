//
//  FromMyCoachHeaderView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromMyCoachHeaderView: UIView {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var coachImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    let skeletonManager = SkeletonManager()

    static func instantiateFromNib() -> FromMyCoachHeaderView? {
        guard let header = R.nib.fromMyCoachHeaderView
            .instantiate(withOwner: self).first as? FromMyCoachHeaderView else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return header
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        coachImageView.circle()
        containerView.maskCorners(corners: [.topRight, .topLeft], radius: Layout.cornerRadius08)
    }

    func configure(with data: FromMyCoachCellViewModel.FromMyCoachDetail) {
        ThemeView.level1.apply(self)
        ThemeText.fromCoachTitle.apply(data.title.uppercased(), to: title)
        skeletonManager.addOtherView(coachImageView)
        coachImageView.setImage(url: data.imageUrl,
                                skeletonManager: self.skeletonManager) { (_) in /* */}
        coachImageView.circle()
    }
}
