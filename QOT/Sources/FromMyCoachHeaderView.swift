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
        ThemeView.level2.apply(self)
        ThemeText.fromCoachTitle.apply(data.title.uppercased(), to: title)
        coachImageView.kf.setImage(with: data.imageUrl, placeholder: R.image.placeholder_user())
        coachImageView.circle()
    }
}
