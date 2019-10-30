//
//  DepartureInfoCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureInfoCell: BaseDailyBriefCell {

    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var departureText: UILabel!
    @IBOutlet private weak var departureImage: UIImageView!

    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureModel: DepartureInfoCellViewModel?
    var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var labelToTop: NSLayoutConstraint!
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(departureText)
        skeletonManager.addOtherView(departureImage)
    }

    func configure(with viewModel: DepartureInfoCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderview?.configure(title: (model.title ?? "").uppercased(), subtitle: nil)
        self.departureModel = model
        skeletonManager.addOtherView(departureImage)
        departureImage.setImage(url: URL(string: model.image ?? ""),
                                skeletonManager: self.skeletonManager)
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureText)
        copyrightURL = model.copyright
        if copyrightURL?.isEmpty ?? true {
            copyrightButtonHeight.constant = 0
            labelToTop.constant = 21
            copyrightLabel.isHidden = true
        }
    }

    @IBAction func copyrightButtonPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: departureModel?.copyright)
    }
}
