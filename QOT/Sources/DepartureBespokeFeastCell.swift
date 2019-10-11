//
//  DepartureBespokeFeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureBespokeText: UILabel!
//    @IBOutlet private weak var departureImage: UIImageView!

    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureBespokeFeastModel: DepartureBespokeFeastModel?
    var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var labelToTop: NSLayoutConstraint!
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(departureBespokeText)
//        skeletonManager.addOtherView(departureImage)
    }

    func configure(with viewModel: DepartureBespokeFeastModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        self.departureBespokeFeastModel = model
//        skeletonManager.addOtherView(departureImage)
//        departureImage.setImage(url: URL(string: model.image ?? ""),
//                                skeletonManager: self.skeletonManager)
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureBespokeText)
        copyrightURL = model.copyright
        if copyrightURL?.isEmpty ?? true {
            copyrightButtonHeight.constant = 0
            labelToTop.constant = 21
            copyrightLabel.isHidden = true
        }
    }

    @IBAction func copyrightButtonPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: departureBespokeFeastModel?.copyright)
    }
}
