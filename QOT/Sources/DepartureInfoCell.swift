//
//  DepartureInfoCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureInfoCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureText: UILabel!
    @IBOutlet private weak var departureImage: UIImageView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureModel: DepartureInfoCellViewModel?
    var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!

    func configure(with viewModel: DepartureInfoCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: bucketTitle)
        self.departureModel = viewModel
        departureImage.kf.setImage(with: URL(string: viewModel?.image ?? ""), placeholder: R.image.preloading())
        ThemeText.dailyBriefSubtitle.apply(viewModel?.text, to: departureText)
        copyrightURL = departureModel?.copyright ?? ""
        copyrightLabel.isHidden = (copyrightURL == "")
    }

    @IBAction func copyrightButtonPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: departureModel?.copyright)
    }
}
