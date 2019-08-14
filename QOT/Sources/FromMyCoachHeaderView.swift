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
        guard let fromMyCoachHeaderView = R.nib.fromMyCoachHeaderView.instantiate(withOwner: self).first as? FromMyCoachHeaderView else {
            log("Cannot load view: (self.Type)", level: .error)
            return nil
        }
        return fromMyCoachHeaderView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        coachImageView.circle()
        containerView.maskCorners(corners: [.topRight, .topLeft], radius: Layout.cornerRadius08)
    }

    func configure(with data: FromMyCoachCellViewModel.FromMyCoachDetail) {
        self.title.text = data.title
        coachImageView.kf.setImage(with: data.imageUrl,
                                   placeholder: R.image.dummy_Profile())
        coachImageView.circle()
    }
}
